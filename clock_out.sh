#!/bin/bash

# Load config
source "$(dirname "$0")/config.sh"

# Random delay within the configured clock-out window
DELAY=$(( RANDOM % (CLOCKOUT_WINDOW_MINUTES * 60) ))
echo "Waiting $DELAY seconds before clocking out..."
sleep $DELAY

# Open Keka dashboard with configured Chrome profile
"$CHROME_PATH" --profile-directory="$CHROME_PROFILE" "$KEKA_URL" &

# Wait for page to load
sleep 6

# Step 1: Click the first Clock-out button
osascript << 'EOF'
tell application "Google Chrome"
  repeat with w in every window
    repeat with t in every tab of w
      if URL of t contains "keka.com" then
        execute t javascript "
          document.querySelectorAll('button').forEach(function(el) {
            var txt = el.innerText ? el.innerText.trim() : '';
            if (txt === 'Clock-out' || txt === 'Clock Out') {
              el.click();
            }
          });
        "
      end if
    end repeat
  end repeat
end tell
EOF

echo "Step 1: Clock-out clicked, waiting for confirmation dialog..."
sleep 3

# Step 2: Click the confirmation Clock-out button
osascript << 'EOF'
tell application "Google Chrome"
  repeat with w in every window
    repeat with t in every tab of w
      if URL of t contains "keka.com" then
        set result to execute t javascript "
          var found = 'not found';
          document.querySelectorAll('button').forEach(function(el) {
            var txt = el.innerText ? el.innerText.trim() : '';
            if (txt === 'Clock-out' || txt === 'Clock Out') {
              el.click();
              found = 'confirmed clock-out';
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

echo "Clock-out done at $(date)"
