Config = {}

-- ═══════════════════════════════════════════════
--  DEBUG
--  Prints framework/target/inventory resolution, every NUI callback that
--  runs (name + result), and background-thread activity (crypto price
--  refresh, loan/savings auto-collection ticks) to the server/client
--  console. Toggle live in-game with /tvbankdebug (restricted via the
--  command.tvbankdebug ACE — see README) instead of editing this and
--  restarting.
-- ═══════════════════════════════════════════════
Config.Debug = true

-- ═══════════════════════════════════════════════
--  FRAMEWORK
-- ═══════════════════════════════════════════════
Config.Framework = 'auto'      -- 'auto' | 'qb' | 'esx'  (auto-detects qb-core / es_extended on start)
Config.Target    = 'tv-textui' -- 'auto' | 'qb-target' | 'ox_target' | 'tv-textui' | 'drawtext' | 'none'
                                -- 'tv-textui' uses your tv-textui resource's ShowTextUI/HideTextUI exports
                                -- 'drawtext' uses each framework's native prompt UI (qb-core DrawText / ESX.TextUI)
                                -- 'auto' picks ox_target > qb-target > tv-textui > drawtext, whichever is available
                                -- 'none' forces a bare custom [E] 3D-text prompt (no framework dependency)
Config.Inventory = 'auto'      -- 'auto' | 'qb-inventory' | 'ox_inventory' | 'esx_inventory' | 'none'
Config.Notify    = 'tv-notify'      -- 'auto' | 'tv-notify' | 'qb-notify' | 'esx-notify' | 'none'
                                -- 'tv-notify' uses your tv-notify resource's client-side Notify export
                                -- 'qb-notify' calls QBCore.Functions.Notify by name
                                -- 'esx-notify' calls ESX.ShowNotification by name
                                -- 'auto' picks tv-notify if it's running, otherwise qb-notify/esx-notify to match your detected framework

-- ESX only: which job grade_name(s) count as "boss" for society access
-- (society deposit/withdraw, approving join requests). Matches real
-- esx_society's own Config.BossGrades convention/default — change this
-- if your job grades use a different name for the top tier (e.g. 'owner',
-- 'chief'). Not used on QBCore, which has its own isboss flag per grade.
Config.ESXBossGrades = { boss = true }

-- ═══════════════════════════════════════════════
--  GENERAL
-- ═══════════════════════════════════════════════
Config.ServerName        = 'TV DEVELOPMENT BANK'
Config.CurrencySymbol    = '$'
Config.TransferFeePct    = 2             -- % fee taken on player-to-player transfers (0 = disabled)
Config.MaxTransferAmount = 250000
Config.DailyTransferCap  = 750000
Config.ATMWithdrawFee    = 1.5           -- % fee for withdrawing cash from an ATM (bank interiors are free)
Config.StatementsToKeep  = 200           -- rows kept per account before pruning
Config.RequireCardForATM = true          -- players need the `bankcard` item to use ATMs at all
Config.MenuSoundsEnabled = true          -- soft interaction sounds in the bank/ATM menu (open/close/click/success/error)

-- ═══════════════════════════════════════════════
--  ATM PIN
-- ═══════════════════════════════════════════════
Config.RequirePinForATM   = true   -- require a 4-digit PIN before ATM actions (cards/PINs auto-created on first use)
Config.PinLockoutAttempts = 3      -- wrong attempts before a temporary lockout
Config.PinLockoutSeconds  = 30

-- ═══════════════════════════════════════════════
--  IBAN — every personal & society account gets a persistent,
--  realistic account number using a real MOD-97-10 checksum
--  (same algorithm real IBANs use), so mistyped transfers get
--  caught before they're attempted.
-- ═══════════════════════════════════════════════
Config.IBAN = {
    countryCode   = 'TV',    -- 2-letter pseudo-country prefix for your server
    bankCode      = 'FLBK',  -- 4-letter bank code embedded in every account number
    accountDigits = 10,      -- length of the random account-number portion
}

-- ═══════════════════════════════════════════════
--  BANK LOCATIONS  (full interface: overview, transfer, society, cards, statements)
-- ═══════════════════════════════════════════════
Config.Banks = {
    { label = 'Fleeca Bank - Downtown Vinewood', coords = vector3(149.9, -1040.46, 29.37), heading = 340.0, blip = true },
    { label = 'Fleeca Bank - Pillbox Hill',       coords = vector3(314.23, -278.83, 54.17), heading = 340.0, blip = true },
    { label = 'Fleeca Bank - Great Ocean Hwy',    coords = vector3(-1212.98, -336.61, 37.78), heading = 210.0, blip = true },
    { label = 'Fleeca Bank - Route 68',           coords = vector3(1175.46, 2706.53, 38.09), heading = 0.0, blip = true },
    { label = 'Fleeca Bank - Sandy Shores',       coords = vector3(-351.28, -49.72, 49.04), heading = 100.0, blip = true },
}

-- ═══════════════════════════════════════════════
--  ATM LOCATIONS  (quick menu: balance, deposit, withdraw, quick-transfer)
--  Optional now — automatic detection (below) finds every ATM prop on the
--  map on its own. Anything listed here just registers immediately at
--  startup instead of waiting for the player to walk near it first.
-- ═══════════════════════════════════════════════
Config.ATMs = {
    vector3(147.16, -1035.68, 29.37),
    vector3(150.6,  -1044.4,  29.37),
    vector3(-1212.7, -330.85, 37.78),
    vector3(1174.5, 2712.3, 38.09),
    vector3(-347.1, -50.5, 49.04),
    vector3(24.4, -946.1, 29.37),
    vector3(-3.5, 6519.6, 31.9),
    vector3(1171.56, 2702.99, 38.22),
    vector3(1172.48, 2702.98, 38.17),
    vector3(33.19, -1348.65, 29.51),
    vector3(289.36, -1256.82, 29.55),
    vector3(289.1, -1282.34, 29.83),
    vector3(-57.21, -1751.95, 29.24),
    vector3(129.48, -1290.79, 29.23),
    vector3(130.01, -1291.7, 29.23),
    vector3(130.36, -1292.41, 29.16),
    vector3(-204.04, -861.2, 30.65),
    vector3(-301.74, -829.74, 32.54),
    vector3(-303.09, -829.5, 32.58),
    vector3(-259.16, -723.42, 33.78),
    vector3(-256.51, -716.02, 33.94),
    vector3(-254.34, -692.78, 33.77),
    vector3(-1827.55, 784.67, 138.19),
    vector3(-2974.75, 380.11, 15.2),
    vector3(-3043.9, 594.32, 7.81),
    vector3(-3040.35, 593.15, 7.83),
    vector3(-3241.28, 997.83, 12.64),
    vector3(-3240.28, 1008.43, 12.94),
    vector3(-3144.77, 1127.7, 20.89),
    vector3(-1091.78, 2708.95, 19.0),
    vector3(540.31, 2671.55, 42.21),
    vector3(1968.32, 3743.22, 32.34),
    vector3(1703.18, 4933.96, 42.12),
    vector3(1687.23, 4815.96, 42.04),
    vector3(1735.16, 6410.24, 34.86),
    vector3(1700.64, 6426.5, 32.25),
    vector3(155.99, 6643.17, 31.78),
    vector3(155.99, 6643.17, 31.78),
    vector3(-95.77, 6457.32, 31.64),
    vector3(-95.77, 6457.32, 31.64),
    vector3(-132.98, 6366.94, 31.71),
    vector3(-282.62, 6226.11, 31.66),
}

Config.ATMModels = { 'prop_atm_01', 'prop_atm_02', 'prop_atm_03' }
                                  -- with ox_target/qb-target, interactions attach to EVERY instance
                                  -- of these props anywhere on the map automatically (no scanning needed)
                                  -- with tv-textui/drawtext/none, the client periodically scans nearby
                                  -- streamed-in objects for these models and registers each one it finds —
                                  -- the Config.ATMs list above is only a head-start for locations you want
                                  -- guaranteed to register immediately without waiting for streaming
Config.ATMAutoDetectInterval = 3000  -- ms between world-object scans (tv-textui/drawtext/none fallback only)
Config.ATMInteractionRadius  = 1.2   -- circular interaction radius around each ATM
Config.BankInteractionRadius = 2.0   -- circular interaction radius inside each bank

-- ═══════════════════════════════════════════════
--  BLIP
-- ═══════════════════════════════════════════════
Config.BlipSprite = 108
Config.BlipColor  = 3
Config.BlipScale  = 0.75

-- ═══════════════════════════════════════════════
--  SOCIETY / BUSINESS ACCOUNTS
--  Shared job accounts (police, ambulance, mechanic, etc). Anyone whose job
--  grade has `isboss = true` (QB) / is flagged boss (ESX) can manage the account.
--  tv-banking is the sole account backend — these are also exposed via
--  qb-management-style exports and esx_society-style events so existing
--  bossmenus / gang menus keep working against tv-banking directly.
-- ═══════════════════════════════════════════════
Config.Societies = {
    police    = { label = 'Los Santos Police Department', startingBalance = 50000 },
    ambulance = { label = 'Los Santos Medical Services',  startingBalance = 25000 },
    mechanic  = { label = 'Bennys Original Motor Works',  startingBalance = 15000 },
    cardealer = { label = 'Premium Deluxe Motorsport',    startingBalance = 20000 },
    government = { label = 'City of Los Santos',          startingBalance = 100000 },
}

-- ═══════════════════════════════════════════════
--  CARD ITEM (cosmetic security layer, optional)
-- ═══════════════════════════════════════════════
Config.CardItem = 'bankcard'    -- set to false to disable the physical inventory item entirely —
                                 -- card ownership is then tracked purely in the database instead,
                                 -- and the dashboard gets a "Destroy Card" button (since there's no
                                 -- physical item for the player to drop/lose) in place of the
                                 -- "Card in inventory" note
Config.CardPrice = 150   -- price to buy a debit card item (deducted from bank balance)

-- ═══════════════════════════════════════════════
--  INVOICES
--  A minimal, self-contained billing system — no external billing resource
--  required. Other scripts bill a player via exports['tv-banking']:CreateInvoice(...)
--  and the player pays it off from the Invoices tab.
-- ═══════════════════════════════════════════════
Config.InvoicesToShow = 50   -- how many outstanding invoices to load at once

-- ═══════════════════════════════════════════════
--  BANK LOANS
--  Players may hold ONE active loan at a time. Loans with a `jobRestriction`
--  only appear for players currently on that job (state job "flex loans").
--  On the due date, tv-banking makes a best-effort collection attempt from
--  the player's bank balance while they're online — it does NOT currently
--  push the account negative; full overdraft/negative-balance support is a
--  separate, not-yet-built feature.
-- ═══════════════════════════════════════════════
Config.Loans = {
    { id = 'entry',       label = 'Fleeca Entry',        amount = 10000,   days = 15 },
    { id = 'welcome',     label = 'Fleeca Welcome',       amount = 20000,   days = 15 },
    { id = 'fifty',       label = 'Fleeca 50',            amount = 50000,   days = 20 },
    { id = 'seventyfive', label = 'Fleeca 75',            amount = 75000,   days = 20 },
    { id = 'officer',     label = 'Fleeca Officer Loan',  amount = 50000,   days = 15, jobRestriction = 'police' },
    { id = 'pacific100',  label = 'Pacific 100',          amount = 100000,  days = 25 },
    { id = 'pacific_ems', label = 'Pacific Supports EMS', amount = 50000,   days = 15, jobRestriction = 'ambulance' },
    { id = 'millionaire', label = 'Pacific Millionaire',  amount = 1000000, days = 45 },
    { id = 'pacific200',  label = 'Pacific 200',          amount = 200000,  days = 25 },
}
Config.LoanCheckIntervalMinutes = 5   -- how often overdue loans are auto-collected from ONLINE players

-- ═══════════════════════════════════════════════
--  SAVINGS / VAULT OFFERS
--  One active offer at a time. Money is locked for the offer's duration;
--  on maturity, players get the principal back plus the bonus percentage.
--  Cancelling early refunds only the principal — no bonus. Matured offers
--  pay out automatically on a periodic check (best-effort, online players
--  only — same limitation as loans/transfers elsewhere in this resource).
-- ═══════════════════════════════════════════════
Config.SavingsOffers = {
    { id = 'save5',           label = 'Save 5% With Fleeca',   pct = 5,  days = 3 },
    { id = 'save10',          label = 'Save 10% With Fleeca',  pct = 10, days = 7 },
    { id = 'save15',          label = 'Save 15% With Fleeca',  pct = 15, days = 10 },
    { id = 'save20',          label = 'Save 20% With Fleeca',  pct = 20, days = 14 },
    { id = 'save25_officers', label = 'Save 25% Officers',     pct = 25, days = 14, jobRestriction = 'police' },
    { id = 'save30_pacific',  label = 'Save 30% With Pacific', pct = 30, days = 21 },
    { id = 'savelives25',     label = 'Save Lives Save 25%',   pct = 25, days = 14, jobRestriction = 'ambulance' },
    { id = 'save35_pacific',  label = 'Save 35% With Pacific', pct = 35, days = 25 },
    { id = 'save40_central',  label = 'Save 40% With Central', pct = 40, days = 30 },
}
Config.SavingsCheckIntervalMinutes = 5

-- ═══════════════════════════════════════════════
--  CRYPTO MARKET
--  Live prices fetched from CoinGecko's free public API — no API key
--  needed. Keep the refresh interval reasonable to stay within their free
--  rate limits.
-- ═══════════════════════════════════════════════
Config.CryptoCoins = {
    { id = 'bitcoin',     symbol = 'BTC',  label = 'Bitcoin' },
    { id = 'ethereum',    symbol = 'ETH',  label = 'Ether' },
    { id = 'tether',      symbol = 'USDT', label = 'TetherUS' },
    { id = 'ripple',      symbol = 'XRP',  label = 'Ripple' },
    { id = 'binancecoin', symbol = 'BNB',  label = 'Binance' },
    { id = 'usd-coin',    symbol = 'USDC', label = 'USD Coin' },
    { id = 'cardano',     symbol = 'ADA',  label = 'Cardano' },
    { id = 'solana',      symbol = 'SOL',  label = 'Solana' },
    { id = 'dogecoin',    symbol = 'DOGE', label = 'Doge' },
}
Config.CryptoPriceRefreshMinutes = 3

-- ═══════════════════════════════════════════════
--  DISCORD BOT INTEGRATION (optional)
-- ═══════════════════════════════════════════════
-- If set, resolves a player's `discord:` identifier to their real Discord
-- username (via the Discord API), for use by future bot-lookup features in
-- server/discord.lua. Leave empty to disable entirely — nothing else in
-- this resource depends on this.
--
-- To get a token: create an application at https://discord.com/developers/applications
-- -> Bot tab -> Reset Token. The bot does NOT need to be in your Discord
-- server or have any special permissions for the basic user-lookup calls;
-- it does need to be in the server for guild-member/role lookups.
Config.DiscordBotToken = ''
Config.DiscordGuildId  = ''

-- ═══════════════════════════════════════════════
--  DISCORD WEBHOOK LOGGING (optional)
-- ═══════════════════════════════════════════════
-- One webhook posts everything; the full URL already contains everything
-- needed to authorize posting — no separate token to configure.
Config.Logging = {
    Enabled = false,
    WebhookURL = '', -- e.g. 'https://discord.com/api/webhooks/XXXXXXXXXXXXXXXXXXX/XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'
    BotName = 'TV Banking',
    BotAvatar = '', -- optional icon URL for the posted messages; leave blank for Discord's default

    -- Independent category toggles — a busy server might want loans/crypto
    -- logged but not every single deposit/withdraw.
    Events = {
        deposit  = true,
        withdraw = true,
        transfer = true,
        request  = true,
        society  = true,
        card     = true,   -- card purchases and PIN create/change (PIN value itself is never logged)
        invoice  = true,
        loan     = true,
        savings  = true,
        crypto   = true,
    },
}

-- ═══════════════════════════════════════════════
--  LOCALES
-- ═══════════════════════════════════════════════
Config.Locale = 'en'
Config.Locales = {
    en = {
        ['not_enough_cash']    = 'You don\'t have enough cash on you.',
        ['not_enough_bank']    = 'You don\'t have enough money in your account.',
        ['deposit_success']    = 'Deposited %s successfully.',
        ['withdraw_success']   = 'Withdrew %s successfully.',
        ['transfer_success']   = 'Sent %s to %s.',
        ['transfer_received']  = 'You received %s from %s.',
        ['invalid_amount']     = 'Enter a valid amount.',
        ['invalid_target']     = 'That player/account could not be found.',
        ['daily_cap_reached']  = 'You\'ve reached your daily transfer limit.',
        ['no_access']          = 'You do not have access to this account.',
        ['card_required']      = 'You need a bank card to use this ATM.',
        ['society_created']    = 'Society account created.',
    },
}

function Locale(key, ...)
    local str = (Config.Locales[Config.Locale] or Config.Locales.en)[key] or key
    if select('#', ...) > 0 then
        return string.format(str, ...)
    end
    return str
end
