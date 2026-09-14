-- ═══════════════════════════════════════════════
--  tv-banking — QBCore uninstall script
--  Run this ONLY if you are removing tv-banking entirely. This permanently
--  deletes every player's balance history, IBANs, cards, loans, savings
--  offers, crypto holdings, and society data stored by this resource.
--  There is no undo — back up first if you're unsure.
-- ═══════════════════════════════════════════════

DROP TABLE IF EXISTS `tv_banking_statements`;
DROP TABLE IF EXISTS `tv_banking_society`;
DROP TABLE IF EXISTS `tv_banking_society_members`;
DROP TABLE IF EXISTS `tv_banking_accounts`;
DROP TABLE IF EXISTS `tv_banking_requests`;
DROP TABLE IF EXISTS `tv_banking_cards`;
DROP TABLE IF EXISTS `tv_banking_invoices`;
DROP TABLE IF EXISTS `tv_banking_loans`;
DROP TABLE IF EXISTS `tv_banking_savings`;
DROP TABLE IF EXISTS `tv_banking_crypto_holdings`;
