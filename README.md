# Keka Automation

Automatically clocks you in and out on Keka every weekday using your existing Chrome profile.

---

## How it works

| Script | Runs | Time window |
|--------|------|-------------|
| `clock_in.sh` | Mon–Fri | Random within `CLOCKIN_START_HOUR` + `CLOCKIN_WINDOW_MINUTES` |
| `clock_out.sh` | Mon–Fri | Random within `CLOCKOUT_START_HOUR` + `CLOCKOUT_WINDOW_MINUTES` |

The scripts are scheduled via macOS **launchd**. The Mac auto-wakes before the clock-in window via `pmset`.

---

## Configuration

**Edit only `config.sh`** — everything else picks up your settings automatically.

```sh
# ── Keka portal URL ───────────────────────────
KEKA_URL="https://your-company.keka.com/#/home/dashboard"

# ── Chrome profile ────────────────────────────
CHROME_EMAIL="you@yourcompany.com"
CHROME_PROFILE="Profile 1"       # run find_profile.py to get this

# ── Clock-in schedule ─────────────────────────
CLOCKIN_START_HOUR=9             # 9 = 9:00 AM
CLOCKIN_WINDOW_MINUTES=60        # random within 60 min → lands 9:00–10:00 AM

# ── Clock-out schedule ────────────────────────
CLOCKOUT_START_HOUR=21           # 21 = 9:00 PM
CLOCKOUT_WINDOW_MINUTES=120      # random within 120 min → lands 9:00–11:00 PM

# ── Chrome app path ───────────────────────────
CHROME_PATH="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
```

### Find your Chrome profile directory

```bash
python3 ~/workspace/keka_automation/find_profile.py
```

This prints a table like:

```
Profile      Email
-------------------------------------------------------
Default      user@gmail.com
Profile 7    work@company.com
...
```

Copy the **Profile** value matching your Keka login email into `CHROME_PROFILE` in `config.sh`.

---

## Setup (first time)

### 1. Prerequisites

- macOS with Google Chrome installed
- Enable JavaScript from Apple Events in Chrome (one-time):
  `View → Developer → Allow JavaScript from Apple Events`

### 2. Edit config.sh

```bash
nano ~/workspace/keka_automation/config.sh
```

Set your `KEKA_URL`, `CHROME_EMAIL`, and `CHROME_PROFILE`.

### 3. Register the scheduled jobs

```bash
launchctl load ~/Library/LaunchAgents/com.keka.clockin.plist
launchctl load ~/Library/LaunchAgents/com.keka.clockout.plist
```

### 4. Enable auto-wake

So the Mac wakes itself up before the clock-in window:

```bash
sudo pmset repeat wakeorpoweron MTWRF 08:58:00
```

> Change `08:58:00` to 2 minutes before your `CLOCKIN_START_HOUR` if you update it.

### 5. Sleep your Mac (don't shut it down)

- Press `⌘ + Option + Power`, or go to  → **Sleep**
- Or just close the lid

---

## Run manually

```bash
# Clock in now
bash ~/workspace/keka_automation/clock_in.sh

# Clock out now
bash ~/workspace/keka_automation/clock_out.sh
```

> Manual runs include the random delay. To skip it, temporarily comment out `sleep $DELAY` in the script.

---

## Logs

| File | Contents |
|------|----------|
| `clock_in.log` | Clock-in output |
| `clock_in_error.log` | Clock-in errors |
| `clock_out.log` | Clock-out output |
| `clock_out_error.log` | Clock-out errors |

```bash
cat ~/workspace/keka_automation/clock_in.log
cat ~/workspace/keka_automation/clock_out.log
```

---

## Disable / Re-enable

```bash
# Disable
launchctl unload ~/Library/LaunchAgents/com.keka.clockin.plist
launchctl unload ~/Library/LaunchAgents/com.keka.clockout.plist

# Re-enable
launchctl load ~/Library/LaunchAgents/com.keka.clockin.plist
launchctl load ~/Library/LaunchAgents/com.keka.clockout.plist
```
