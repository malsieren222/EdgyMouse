#!/usr/bin/env bash

path=$(pwd)
X1="$path/X.dat"
Y1="$path/Y.dat"
ratiofile="$path/ratio.dat"
alarm="$path/alarm.dat"

i=0
file=false

# Ensure baseline files exist (or create them)
if [[ -f "$X1" && -f "$Y1" ]]; then
  file=true
else
  # initialize to 0 if missing
  echo "0" > "$X1"
  echo "0" > "$Y1"
  echo "0" > "$ratiofile"
  echo "0" > "$alarm"
  file=true
fi

while true; do
  sleep 2

  if [[ "$file" == true ]]; then
    # Populates X and Y variables
    eval "$(xdotool getmouselocation --shell)"

    if nc -zw1 google.com 443; then
      echo "We have connectivity to the internet."
      connectivity="0"
    else
      echo "No connection."
      connectivity="1"
    fi

    # Read previous stored coordinates
    # (remove sudo unless you truly need it)
    X3=$(cat "$X1" | xargs)
    Y3=$(cat "$Y1" | xargs)

    # Default to 0 if empty
    X3=${X3:-0}
    Y3=${Y3:-0}

    # Compute deltas
    D1=$(( X3 - X ))
    D2=$(( Y3 - Y ))

    # Avoid division by zero
    if [[ "$D2" -eq 0 ]]; then
      ratio="0"
    else
      ratio=$(( D1 / D2 ))
    fi

    ratiosaved=$(cat "$ratiofile" 2>/dev/null | xargs)
    ratiosaved=${ratiosaved:-0}

    echo "ratio is $ratio while ratiofile is $ratiosaved"

    if [[ "$ratio" != "$ratiosaved" && "$i" -gt 0 && "$connectivity" = "0" ]]; then
      echo "Movement detected! Triggering security!"
      echo "1" > "$alarm"
    else
      echo "0" > "$alarm"
    fi

    # Save current coords and ratio
    echo "$X" > "$X1"
    echo "$Y" > "$Y1"
    echo "$ratio" > "$ratiofile"

    i=$(( i + 1 ))
  fi
done
