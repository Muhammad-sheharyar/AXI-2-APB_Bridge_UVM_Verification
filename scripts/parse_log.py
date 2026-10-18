#!/usr/bin/env python3
import sys
import os

def parse_log(filepath):
    if not os.path.exists(filepath):
        print(f"ERROR: Log file '{filepath}' not found.")
        return

    capture_summary = False
    summary_lines = []

    with open(filepath, 'r', errors='ignore') as f:
        for line in f:
            # Start capturing when we see the report summary header
            if "--- UVM Report Summary ---" in line or "--- UVM Report counts by severity" in line:
                capture_summary = True
            
            # Stop capturing when we hit the end of the UVM summary block
            if capture_summary:
                if "$finish" in line or "V C S" in line:
                    break
                summary_lines.append(line.rstrip())

    # Print only the captured summary block
    if summary_lines:
        print("\n".join(summary_lines))
    else:
        print("UVM Report Summary not found in the log.")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 parse_log.py <path_to_log_file>")
        sys.exit(1)
    
    parse_log(sys.argv[1])