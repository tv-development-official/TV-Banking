-- ═══════════════════════════════════════════════
--  tv-banking — QBCore database schema
--  Import this file if your server runs QBCore.
--  (account_ref stores each player's citizenid)
-- ═══════════════════════════════════════════════

CREATE TABLE IF NOT EXISTS `tv_banking_statements` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `account_type` ENUM('personal','society') NOT NULL DEFAULT 'personal',
  `account_ref` VARCHAR(64) NOT NULL COMMENT 'citizenid for personal accounts, society name for society accounts',
  `kind` ENUM('deposit','withdraw','transfer_in','transfer_out') NOT NULL,
  `category` VARCHAR(32) NOT NULL DEFAULT 'other' COMMENT 'deposit, withdraw, transfer, society, request, bill, shop, gas, other',
  `amount` INT(11) NOT NULL DEFAULT 0,
  `balance_after` INT(11) NOT NULL DEFAULT 0,
  `reason` VARCHAR(255) DEFAULT '',
  `actor` VARCHAR(64) DEFAULT '' COMMENT 'citizenid of whoever performed the action',
  `counterparty_iban` VARCHAR(34) DEFAULT NULL COMMENT 'the other party''s IBAN, for transfer/request rows',
  `counterparty_name` VARCHAR(128) DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `account_ref_idx` (`account_ref`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `tv_banking_society` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(64) NOT NULL UNIQUE COMMENT 'matches a job name in qb-core/shared/jobs.lua',
  `label` VARCHAR(128) NOT NULL DEFAULT '',
  `balance` INT(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `tv_banking_accounts` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `account_type` ENUM('personal','society') NOT NULL DEFAULT 'personal',
  `owner_ref` VARCHAR(64) NOT NULL COMMENT 'citizenid for personal accounts, society name for society accounts',
  `iban` VARCHAR(34) NOT NULL UNIQUE,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `account_unique` (`account_type`, `owner_ref`),
  KEY `iban_idx` (`iban`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `tv_banking_requests` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `requester_identifier` VARCHAR(64) NOT NULL COMMENT 'citizenid of who is asking to be paid',
  `requester_name` VARCHAR(128) NOT NULL DEFAULT '',
  `requester_iban` VARCHAR(34) NOT NULL,
  `payer_identifier` VARCHAR(64) NOT NULL COMMENT 'citizenid of who is being asked to pay',
  `amount` INT(11) NOT NULL DEFAULT 0,
  `reason` VARCHAR(255) DEFAULT '',
  `status` ENUM('pending','paid','declined') NOT NULL DEFAULT 'pending',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `payer_idx` (`payer_identifier`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `tv_banking_cards` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `owner_ref` VARCHAR(64) NOT NULL COMMENT 'citizenid',
  `card_number` VARCHAR(32) DEFAULT NULL,
  `card_pin` VARCHAR(8) DEFAULT NULL,
  `pin_set` TINYINT(1) NOT NULL DEFAULT 0,
  `active` TINYINT(1) DEFAULT 0 COMMENT 'card purchased/owned — only meaningful when Config.CardItem is false (SQL-tracked mode)',
  PRIMARY KEY (`id`),
  UNIQUE KEY `owner_ref_idx` (`owner_ref`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `tv_banking_invoices` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `identifier` VARCHAR(64) NOT NULL,
  `issuer_label` VARCHAR(128) NOT NULL DEFAULT '',
  `title` VARCHAR(128) NOT NULL DEFAULT '',
  `amount` INT(11) NOT NULL DEFAULT 0,
  `status` ENUM('pending','paid','cancelled') NOT NULL DEFAULT 'pending',
  `due_at` DATETIME DEFAULT NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `identifier_idx` (`identifier`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `tv_banking_loans` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `identifier` VARCHAR(64) NOT NULL,
  `loan_key` VARCHAR(64) NOT NULL,
  `label` VARCHAR(128) NOT NULL DEFAULT '',
  `principal` INT(11) NOT NULL DEFAULT 0,
  `remaining` INT(11) NOT NULL DEFAULT 0,
  `days` INT(11) NOT NULL DEFAULT 0,
  `taken_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `due_at` DATETIME DEFAULT NULL,
  `status` ENUM('active','paid') NOT NULL DEFAULT 'active',
  PRIMARY KEY (`id`),
  KEY `identifier_idx` (`identifier`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `tv_banking_savings` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `identifier` VARCHAR(64) NOT NULL,
  `offer_key` VARCHAR(64) NOT NULL,
  `label` VARCHAR(128) NOT NULL DEFAULT '',
  `pct` INT(11) NOT NULL DEFAULT 0,
  `amount` INT(11) NOT NULL DEFAULT 0,
  `payout` INT(11) NOT NULL DEFAULT 0,
  `started_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `matures_at` DATETIME DEFAULT NULL,
  `status` ENUM('active','completed','cancelled') NOT NULL DEFAULT 'active',
  PRIMARY KEY (`id`),
  KEY `identifier_idx` (`identifier`, `status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `tv_banking_crypto_holdings` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `identifier` VARCHAR(64) NOT NULL,
  `coin_id` VARCHAR(32) NOT NULL,
  `amount` DECIMAL(24,8) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `identifier_coin_unique` (`identifier`, `coin_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `tv_banking_society_members` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `society_name` VARCHAR(64) NOT NULL,
  `identifier` VARCHAR(64) NOT NULL COMMENT 'citizenid',
  `name` VARCHAR(128) NOT NULL DEFAULT '',
  `status` ENUM('pending','approved') NOT NULL DEFAULT 'pending',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `society_member_unique` (`society_name`, `identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
