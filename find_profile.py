#!/usr/bin/env python3
"""
Run this to find which Chrome profile directory matches your email.
Usage: python3 find_profile.py
"""

import json
import os
import glob

chrome_dir = os.path.expanduser("~/Library/Application Support/Google/Chrome")

if not os.path.exists(chrome_dir):
    print("Chrome not found at:", chrome_dir)
    exit(1)

print(f"{'Profile':<12} {'Email':<40}")
print("-" * 55)

for profile in sorted(os.listdir(chrome_dir)):
    pref_file = os.path.join(chrome_dir, profile, "Preferences")
    if not os.path.isfile(pref_file):
        continue
    try:
        with open(pref_file, "r") as f:
            data = json.load(f)
        accounts = data.get("account_info", [])
        email = accounts[0].get("email", "N/A") if accounts else "N/A"
        print(f"{profile:<12} {email:<40}")
    except Exception:
        pass
