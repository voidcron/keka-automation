#!/bin/bash

# Load config
source "$(dirname "$0")/config.sh"

# Random delay within the configured clock-in window
DELAY=$(( RANDOM % (CLOCKIN_WINDOW_MINUTES * 60) ))
echo "Waiting $DELAY seconds before clocking in..."
sleep $DELAY

# Open Keka dashboard with configured Chrome profile
"$CHROME_PATH" --profile-directory="$CHROME_PROFILE" "$KEKA_URL" &

# Wait for page to load
sleep 6

# Click Web Clock-In button
osascript << 'EOF'
tell application "Google Chrome"
  repeat with w in every window
    repeat with t in every tab of w
      if URL of t contains "keka.com" then
        set result to execute t javascript "
          var found = 'not found';
          document.querySelectorAll('button').forEach(function(el) {
            var txt = el.innerText ? el.innerText.trim() : '';
            if (txt === 'Web Clock-In' || txt === 'Clock-in' || txt === 'Clock In') {
              el.click();
              found = 'clicked: ' + txt;
            }
          });
          found;
        "
        return result
      end if
    end repeat
  end repeat
end tell
EOF

echo "Clock-in done at $(date)"
