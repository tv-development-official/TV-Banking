# tv-banking

A modern, vibrant banking system for FiveM — **works out of the box on both QBCore and ESX**, no edits needed for either framework. Built to match the TV Development visual identity (dark neon-blue UI, glowing borders, chrome/blue gradient type).

## Features

- Auto-detects **QBCore** or **ESX** on resource start (or force it in `config.lua`)
- Personal balance stays tied to your framework's **native** cash/bank money — every other script (shops, garages, paychecks, etc.) keeps working normally
- Full **ATM** quick-menu and a full-scale **Bank** interface — banks are the only mapped locations (one blip each), each with exactly one circular interaction zone inside; ATMs have an interaction point but no blip
- Dashboard-style overview: a real 7-day spending chart, a card widget showing your IBAN and balance, a spending-by-category breakdown, and a "Most Sent" quick-transfer list built from your own transfer history
- **Money Requests** — ask another player to pay you by their IBAN; they see it in a notification-bell dropdown with Pay/Decline
- **IBAN-style account numbers** for every personal and society account, using the real MOD-97-10 checksum (ISO 13616) — mistyped transfers get caught by the checksum instantly, client and server side, before money ever moves
- Player-to-player **and player-to-society transfers** by IBAN (pay a business or department directly), with configurable fee % and daily cap
- **Transaction ledger** (statements) for personal and society accounts, each row categorized (deposit/withdraw/transfer/society/request/bill/shop/gas/other) — powers both the Statements tab and the spending-breakdown chart
- **Society / business accounts** (police, ambulance, mechanic, dealership, government by default — fully configurable) with boss-only deposit/withdraw
- **ATM PIN system** — cards are auto-provisioned, but no PIN exists until the player creates one; the dashboard shows "Create PIN" first, then "Change PIN" once one is set (requiring the current PIN to change it). Without a card in inventory, ATMs refuse access entirely and notify the player — checked server-side before the UI ever opens. With a card but no PIN yet, the ATM forces PIN creation on the spot before granting access; once a PIN exists, every future visit requires it, with server-side lockout after repeated wrong attempts.
- **Debit card purchase** — a "Buy Debit Card" button on the dashboard gives the player `Config.CardItem` in their inventory (QBCore/ESX/ox_inventory all supported) for `Config.CardPrice`; already owning one disables repurchasing, checked server-side. Set `Config.CardItem = false` to drop the physical item entirely — ownership is then tracked purely in the database, and the dashboard shows a **Destroy Card** button in its place (resets ownership, PIN, and card number, since there's no physical item to drop/lose).
- **Bank Loans** — nine configurable loan products (some job-restricted, e.g. an officer/EMS flex loan), one active loan at a time, partial or full payoff from a "My Loan" panel with a live circular progress ring. Overdue loans are auto-collected (best-effort, online players only) on a periodic check.
- **Invoices** — a self-contained billing system (no external billing resource needed). Other resources bill a player via `exports['tv-banking']:CreateInvoice(...)`; the player pays it off from the Invoices tab, styled as a ticket with a due-date/overdue indicator.
- **Society join-request workflow** — non-boss employees whose job matches a configured society can request view access to that society's balance/IBAN; the boss approves or declines from their own Society tab
- **Savings/Vault offers** — nine configurable offers (some job-restricted), one active offer at a time. Locked money earns a bonus percentage on maturity; cancelling early refunds only the principal. Maturity payouts run on the same best-effort periodic check as loans.
- **Crypto Market** — real, live prices for 9 coins fetched from CoinGecko's free public API on a timer (no API key, no extra resource dependency). Players buy with a USD amount, sell partial or full holdings; everything is tracked to 8 decimal places.
- **Discord webhook logging** — every money-moving action (deposits, withdrawals, transfers, requests, society, card purchases/PIN changes, invoices, loans, savings, crypto) posts a log embed to a single Discord channel via `Config.Logging`, with independent per-category on/off toggles (`Config.Logging.Events`) and semantic color-coding (money/success/warning/info). Matches tv-garages' logging convention — global `LogEvent`/`Field` functions, set directly in `config.lua`.
- Soft interaction sounds on menu open/close, button clicks, and every toast (success/error/warning/info) — synthesized in-browser via the Web Audio API rather than bundled audio files, so there's nothing extra to ship. Toggle with `Config.MenuSoundsEnabled`.
- Animated neon border (a bright arc slowly travels around every panel) and a PlayStation-style ambient background — slow-drifting blurred gradient blobs plus rising glowing particles — behind the ATM/bank UI, all pure CSS/JS with no image assets.
- Both the ATM and full bank menu have a clickable close button (in addition to ESC), and the world interaction prompt (drawtext/tv-textui/bare `[E]` fallback modes) automatically hides itself while the menu is open instead of lingering on screen underneath it.
- Society account exports use `qb-management`-style naming so existing bossmenus/gang menus can integrate directly with tv-banking as their account backend:
  - `GetAccount`, `AddMoney`, `RemoveMoney`, `CreateAccount`, `HasAccessToAccount`
- Compatibility events for scripts written against `esx_society` and `esx_addonaccount`, matching their real, documented access model exactly (any employee of the matching job, not just a boss — deliberately different from our own stricter native NUI, which stays boss-only):
  - `esx_society:getSociety`, `esx_society:depositMoney`, `esx_society:withdrawMoney`
  - `esx_addonaccount:getSharedAccount` (the deeper two-step pattern some third-party scripts use — `getSociety`'s `.account` field, e.g. `"society_police"`, feeds straight into this) — returns an account object with `.money`/`.addMoney()`/`.removeMoney()`/`.setMoney()`, all backed by the same `tv_banking_society` table
- `ChargePersonalAccount` export for billing/shop/fuel resources to deduct from a player's bank account with a proper spending category, so external charges show up correctly in the chart and statements
- Interaction system auto-detects `ox_target` / `qb-target` / `tv-textui` / native framework drawtext (`qb-core`'s `DrawText` or ESX's `TextUI`), and falls back further to a bare `[E]` 3D-text prompt if none of those are present — configurable in `Config.Target`. Every interaction point is a genuine circular radius (`ox_target`'s sphere zone / `qb-target`'s PolyZone-backed circle zone, or an equivalent proximity check in the fallback), not a box.
- Notifications auto-detect `tv-notify` if it's running, otherwise call `QBCore.Functions.Notify`/`ESX.ShowNotification` by name to match your detected framework — configurable in `Config.Notify`.
- With `ox_target` active, ATMs use **model-based targeting** (`Config.ATMModels`, default `prop_atm_01`/`02`/`03`) — every native ATM prop anywhere on the map becomes interactive automatically, a native capability of that target system. `qb-target` deliberately doesn't use its own equivalent (`AddTargetModel`) for this — its model-based targeting relies on raycasting against the prop's own collision mesh, which is unreliable for certain props including ATMs (a documented qb-target limitation: the interaction registers with no error, but the option never actually appears, regardless of how it's configured). `qb-target`, along with `tv-textui`/drawtext/none, instead gets the same map-wide coverage through periodic scanning of nearby streamed-in objects, deduped by coordinate (rounded to the nearest centimeter — just enough to absorb floating-point noise on the same static prop, without merging two ATMs mounted close together on the same wall) so each physical ATM only ever registers once — `Config.ATMs` is just an optional head start for locations you want available immediately at startup rather than waiting for someone to walk past them.
- Fully responsive NUI with toast notifications matching the TV Development notification style

## Installation

1. Copy the `tv-banking` folder into your resources directory.
2. (Optional but recommended) Import the SQL file that matches your framework for a clean, trackable migration:
   - QBCore → `sql/qbcore.sql`
   - ESX → `sql/esx.sql` — **this one isn't purely optional if you want the debit card purchase to work**: unlike QBCore (which defines items in a shared Lua file), ESX stores item definitions in the database, so `sql/esx.sql` includes an `INSERT IGNORE INTO items` line registering `bankcard`. The automatic table migration below does *not* cover this — it's ESX-specific and only in this file.
   (Only import one — both create the same table names, just tuned for each framework's identifier convention.)

   **You don't have to do this manually** — `server/database.lua` automatically runs the same `CREATE TABLE IF NOT EXISTS` statements the first time the resource starts against a fresh database, so a missed SQL import won't crash the resource. Importing the file yourself is just the cleaner option if you like tracking schema changes in source control.
3. Add to your `server.cfg`:
   ```
   ensure oxmysql
   ensure qb-core        # or es_extended
   ensure tv-banking
   ```
4. (Optional) If you want Discord webhook logging or the bot-lookup features, open `config.lua` and fill in `Config.Logging` (`Enabled = true`, `WebhookURL`, optionally `BotName`/`BotAvatar`) and, if you want the bot lookup helpers, `Config.DiscordBotToken` / `Config.DiscordGuildId`.
5. (Optional) Adjust `config.lua` — bank/ATM locations, fees, transfer limits, societies, target system.
6. Restart the resource.

## Uninstalling

Run the uninstall SQL matching your framework — `sql/uninstall_qbcore.sql` or `sql/uninstall_esx.sql` — before removing the resource. This permanently drops every tv-banking table (balances history, IBANs, cards, loans, savings, crypto holdings, society data). There's no undo, so back up first if you're not certain. On ESX, it also deletes the `bankcard` item definition from the `items` table — check no player inventory still holds one first, or other scripts/ESX itself may error looking up its metadata.

## Usage

- Players can walk up to any ATM or bank location and interact (target or `[E]`) to open the UI.
- `/bank` command also opens the full banking interface anywhere.
- Boss-graded job members automatically see a **Society** tab for their organization's shared account.

### Exports (server)

```lua
-- Society / business accounts
exports['tv-banking']:GetAccount('police')                       -- balance
exports['tv-banking']:AddMoney('police', 5000, 'Grant')
exports['tv-banking']:RemoveMoney('police', 1000, 'Equipment')
exports['tv-banking']:CreateAccount('newjob', 'New Society', 0)
exports['tv-banking']:HasAccessToAccount(source, 'police')

-- Charge a player's personal account with a proper spending category
exports['tv-banking']:ChargePersonalAccount(identifier, 250, 'gas', 'Fuel')

-- Bill a player an invoice they pay off from the Invoices tab.
-- dueInSeconds is optional (nil = no due date shown).
exports['tv-banking']:CreateInvoice(identifier, 'LSPD', 'Traffic Penalty', 150, 259200)

-- Which framework tv-banking detected/is using ('qb' | 'esx' | nil)
exports['tv-banking']:GetFramework()
```

### Exports (client)

```lua
exports['tv-banking']:OpenBankingMenu('bank')  -- or 'atm'
```

## Notes

- `Config.Framework` defaults to `'auto'`; set it explicitly if you run something unusual alongside qb-core/es_extended.
- The Crypto Market needs the server to have outbound internet access to reach `api.coingecko.com`; if that's blocked (some hosts restrict it), coin prices will read as `$0` and buy/sell will fail with "Price data unavailable" until it's fetched successfully. `Config.CryptoPriceRefreshMinutes` controls how often it refreshes — keep it reasonable to stay within CoinGecko's free-tier rate limits.
- Loans and Savings offers use the same best-effort auto-collection/payout pattern: a periodic check against **online** players only, since money can't be touched for someone who isn't connected. This is consistent with the online-only limitation already present for transfers and money requests elsewhere in this resource.
- `Config.Debug` (default `false`) enables verbose console logging — framework/target/inventory resolution, every NUI callback that runs (name + result), and background-thread activity (crypto price refresh, loan/savings auto-collection ticks). Toggle it live without restarting via `/tvbankdebug`, restricted through the `command.tvbankdebug` ACE (same pattern as tv-garages' `/garageadmin`) — grant it in-game via `add_ace group.admin command.tvbankdebug allow` in `server.cfg`; the server console always has access.
- `Config.Target` is currently pinned to `'tv-textui'`, using your tv-textui resource's `ShowTextUI`/`HideTextUI` exports for every interaction prompt. Set to `'auto'` to pick ox_target → qb-target → tv-textui → drawtext automatically (falling back gracefully if tv-textui isn't installed), or `'none'` for a dependency-free bare `[E]` 3D-text prompt.
- `Config.Notify` (default `'auto'`) picks `tv-notify` if it's running, otherwise `'qb-notify'`/`'esx-notify'` — explicit named modes calling `QBCore.Functions.Notify`/`ESX.ShowNotification` directly, rather than a single generic "native" catch-all that branches on detected framework internally. This also means you can force one explicitly (e.g. `Config.Notify = 'qb-notify'`) if your setup ever misreports its own framework detection. All notifications — server- and client-triggered alike — are routed through the client-side resolution in `bridge/client.lua` via a private relay event, rather than firing a framework-specific event (like `esx:showNotification`) directly. This matters because `tv-notify` doesn't listen for ESX's notify event at all (only an opt-in, disabled-by-default QBCore hook) — firing that event directly, like earlier versions of this resource did, means notifications silently fall through to native ESX regardless of what `tv-notify` is configured to do.
- `Config.IBAN` controls the country prefix / bank code embedded in every generated account number. Changing these after launch is safe — it only affects newly generated IBANs, existing ones stay valid and stored as-is.
- `Config.RequirePinForATM` (default `true`) toggles the ATM PIN-lock screen; `Config.PinLockoutAttempts` / `Config.PinLockoutSeconds` control the brute-force lockout window. The lock only ever triggers for players who've actually created a PIN — first-time card use prompts them to create one on the spot instead.
- `Config.RequireCardForATM` (default `true`) — without a card (see `Config.CardItem` below for what "having a card" means), the ATM refuses to open at all (checked server-side, not just a label change).
- `Config.CardItem` doubles as the card-ownership tracking mode. As a string (default `'bankcard'`), ownership is a real inventory item — `TVBank.HasCard(source)` checks it via `HasItem`. Set it to `false` to track ownership purely via the `active` column on `tv_banking_cards` instead (no item at all); `TVBank.HasCard` is the single function every ATM/purchase check goes through, so nothing needs to know which mode is active except that one function. **Migration note**: on an existing install, the `active` column was previously always `1` for every player regardless of purchase status (it was unused before this feature) — if you switch an existing server from item-mode to `false`, every player who's ever opened the bank menu will incorrectly appear to already own a card. Run `UPDATE tv_banking_cards SET active = 0;` once after making the switch to clear that stale default. Fresh installs don't need this — the schema's default is already `0`.
- `Config.ATMAutoDetectInterval` (default `3000`ms) controls how often the client scans nearby streamed-in objects for ATM props when using `tv-textui`/drawtext/none. Only relevant for those modes — `ox_target`/`qb-target` handle model-wide detection natively with no scanning at all.
- `Config.Logging` (`Enabled`, `WebhookURL`, `BotName`, `BotAvatar`, `Events`) controls Discord webhook logging, matching tv-garages' `Config.Logging`/global `LogEvent`/`Field` convention exactly — one webhook posts everything, with per-category toggles rather than per-category URLs. `Config.DiscordBotToken` / `Config.DiscordGuildId` are separate, only used by the optional bot-lookup helpers. `LogEvent(...)` is already wired into every money-moving action across the resource (deposits, withdrawals, transfers, requests, society, cards, invoices, loans, savings, crypto) via `server/discord.lua`, and simply no-ops if `Config.Logging.Enabled` is `false` or `WebhookURL` is left empty. The bot-lookup helpers (`TVBank.Discord.GetUser`, `GetGuildMember`, `HasRole`) aren't called by anything yet — they're available for a future feature.
- `Config.Inventory` (default `'auto'`) picks between `ox_inventory`, `tv-inventory`, your framework's native inventory, or none — used for the debit card purchase, and for cash. When `tv-inventory` is active, "cash on hand" (ATM deposit/withdraw, the dashboard's Cash figure) reads and writes its `cash` inventory item directly instead of a framework-internal number, since that's the actual source of truth for physical cash in that system — bank balance stays with the framework either way, since tv-inventory doesn't manage bank money at all. You'll need to define `Config.CardItem` (default `'bankcard'`) as an actual item in your inventory system for the debit card purchase to succeed; if the item isn't registered there, the purchase is automatically refunded rather than silently eating the player's money.
- **On ESX specifically**: `es_extended` loads its item list from the `items` table into memory once at boot — it does not re-read the table live. If you import `sql/esx.sql` (or otherwise add the `bankcard` row) *after* `es_extended` has already started, the debit card purchase will fail every time even though the row exists in the database, because ESX doesn't know the item exists yet. Restart `es_extended` (or the whole server) after adding the item. When this is the cause, the console always prints `ESX item "bankcard" is not registered — import sql/esx.sql and restart es_extended` (this check runs regardless of `Config.Debug`).
- `Config.ESXBossGrades` (default `{ boss = true }`) controls which ESX job `grade_name`(s) count as "boss" for society access — deposit/withdraw, approving join requests. Matches real `esx_society`'s own `Config.BossGrades` convention; change it if your job grades use a different name for the top tier (`'owner'`, `'chief'`, etc.). QBCore isn't affected — it has its own `isboss` flag per grade already.
- The `esx_society`/`esx_addonaccount` compatibility events intentionally check only `job.name == society name`, not boss status, matching real `esx_society`'s actual (looser) access model — a third-party script calling these events expects that exact behavior. An earlier version of `esx_society:withdrawMoney` had no job check at all, meaning any connected client could call it directly and drain any society's funds regardless of their own job; that's fixed now. This is a different, deliberately stricter, security boundary from our own native NUI callbacks (`societyDeposit`/`societyWithdraw`), which remain boss-only.
- `Config.Target = 'drawtext'` on ESX calls `ESX.TextUI()`/`ESX.HideUI()`, which are themselves thin wrappers around the separate `esx_textui` sub-resource — if a server has removed or replaced `esx_textui` (some do, in favor of `ox_lib`'s `showTextUI`), those calls will silently print a warning and show nothing. This is inherent to ESX's own dependency chain, not something tv-banking can work around; `Config.Target = 'tv-textui'` (the current default) or `'ox_target'`/`'qb-target'` avoid it entirely.
- If you add new `TINYINT(1)` columns later, read them back through `TVBank.IsTrue(value)` rather than `value == 1` — oxmysql's driver can return these as either the number `1`/`0` or the Lua boolean `true`/`false` depending on config, and `true == 1` is always `false` in Lua.
- If you add new `DATE`/`DATETIME`/`TIMESTAMP` columns, wrap them in `DATE_FORMAT(column, '...')` in the SQL query rather than selecting them raw — the raw value can cross the Lua bridge as an epoch-millisecond number rather than a string, which silently breaks both on-screen display and any string-based date comparisons (this was the root cause of the spending chart always showing zero, and of the Savings/Loans "Start"/"Due" fields showing raw numbers like `1787904266000`). Where client-side code needs to do date math (e.g. the invoice overdue check, the savings maturity ring), keep the raw column selected *alongside* a separate `_display` alias for the formatted text — see `getActiveSavings`/`getActiveLoan`/`getInvoices` for the pattern.
- Transfers still accept a raw server ID or citizenid/identifier as a fallback (handy for admin/dev testing), but the UI only ever shows and encourages IBAN.
- **Do not add `backdrop-filter` anywhere in `html/style.css`.** FiveM's NUI renders via off-screen CEF compositing and doesn't blend `backdrop-filter` correctly — it renders as a solid opaque block instead of a translucent blur, even though DevTools will show the CSS as "correct." Use plain `rgba()` backgrounds for translucent panels instead.
- Menu sounds use the Web Audio API's `AudioContext`, which some browsers keep suspended until a genuine user gesture inside the page. Since the menu opens from an in-world keypress (not a click inside the NUI itself), the very first "open" sound in a session may be silent on some CEF builds — every sound after that (which follows an actual click inside the page) plays normally. This is a browser characteristic, not a bug to chase further.
- `html/index.html` loads `style.css`/`script.js` with a `?v=1.1.2` cache-busting query string. FiveM's NUI browser caches assets by file path, not content, so **bump that version number every time you edit `style.css` or `script.js`**, or your changes won't show up in-game even after a resource restart.
- All money movement goes through the framework bridge (`bridge/server.lua`), so if you're on a QBCore fork or ESX Legacy with slightly different function names, that's the only file you should need to touch.

## Roadmap

All originally planned systems (Bank Loans, Invoices, Savings/Vault, Crypto Market) are now built. Future additions would come from new requests.
