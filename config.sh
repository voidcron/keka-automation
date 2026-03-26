# ─────────────────────────────────────────────
#  Keka Automation — Configuration
#  Edit this file once and everything else is set.
# ─────────────────────────────────────────────

# ── Keka portal URL ───────────────────────────
# Replace with your company's Keka URL
KEKA_URL="https://your-company.keka.com/#/home/dashboard"

# ── Chrome profile ────────────────────────────
# The email you use to log into Keka
CHROME_EMAIL="you@yourcompany.com"

# The Chrome profile directory linked to that email.
# Run this in terminal to find yours:
#   python3 ~/workspace/keka_automation/find_profile.py
CHROME_PROFILE="Profile 1"

# ── Clock-in schedule ─────────────────────────
# Script fires at CLOCKIN_START_HOUR:00, then waits a random delay
# so the actual clock-in lands anywhere within the window.
CLOCKIN_START_HOUR=9           # 9  = 9:00 AM
CLOCKIN_WINDOW_MINUTES=60      # 60 = random between 9:00–10:00 AM

# ── Clock-out schedule ────────────────────────
CLOCKOUT_START_HOUR=21         # 21 = 9:00 PM
CLOCKOUT_WINDOW_MINUTES=120    # 120 = random between 9:00–11:00 PM

# ── Chrome app path ───────────────────────────
# Change only if Chrome is installed in a non-standard location
CHROME_PATH="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
