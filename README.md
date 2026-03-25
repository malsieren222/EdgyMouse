# EdgyMouse
 
**Input-based door trigger and activity monitor for Linux.**
 
A lightweight Bash script that uses a spare mouse as a physical door sensor. When the mouse moves (triggered by door opening), the script detects the change and raises an alert. Ideal for use on a Raspberry Pi mounted near a door entrance.
 
## How It Works
 
1. The script polls mouse coordinates every 2 seconds using `xdotool`
2. Previous coordinates are persisted to disk for state tracking between cycles
3. A movement ratio is calculated to detect meaningful changes
4. A network connectivity check runs each cycle (`nc` to verify internet access)
5. If movement is detected and connectivity is confirmed, an alarm is triggered
 
## Features
 
- **State persistence** — coordinates and ratios saved to `.dat` files between iterations
- **Connectivity check** — only alerts when network is available
- **Behavioral change detection** — ratio-based logic filters noise from real movement
 
## Requirements
 
- `xdotool` — `sudo apt-get install xdotool`
- `netcat` (`nc`) — usually pre-installed on most Linux distros
 
## Usage
 
```bash
chmod +x EdgyMouse.sh
./EdgyMouse.sh
```
 
Press `Ctrl+C` to stop.
 
## Tech
 
`Bash` · `xdotool` · `Linux`
 
