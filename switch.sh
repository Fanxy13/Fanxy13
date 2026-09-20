#!/bin/bash
# Swap the profile README to another season.
#   ./switch.sh autumn      -> copies README.autumn.md over README.md
#   ./switch.sh             -> picks the season from today's date
set -eu
cd "$(dirname "$0")"

season="${1:-}"
if [ -z "$season" ]; then
  m=$(date +%-m)
  if   [ "$m" -ge 3 ] && [ "$m" -le 5 ];  then season=spring
  elif [ "$m" -ge 6 ] && [ "$m" -le 8 ];  then season=summer
  elif [ "$m" -ge 9 ] && [ "$m" -le 11 ]; then season=autumn
  else season=winter; fi
fi

src="README.$season.md"
[ -f "$src" ] || { echo "no such season: $season (spring summer autumn winter)" >&2; exit 1; }

cp "$src" README.md
echo "README.md is now $season"

if [ "${2:-}" = "--push" ]; then
  git add README.md
  git commit -qm "season: $season"
  git push -q
  echo "pushed"
fi
