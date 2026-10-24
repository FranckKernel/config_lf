#!/bin/sh
# Usage: trash.sh put FILE... | restore | undo | empty

if command -v trash-put >/dev/null 2>&1; then
	backend=trashcli
elif command -v trashy >/dev/null 2>&1; then
	backend=trashy
elif [ "$(uname -s)" = Darwin ]; then
	backend=finder
else
	printf 'No trash tool found (install trashy or trash-cli).\n' >&2
	exit 1
fi

action=$1
shift

case "$action" in
put)
	for f in "$@"; do
		case "$backend" in
		finder)
			abs=$(cd "$(dirname "$f")" && pwd -P)/$(basename "$f")
			osascript \
				-e 'on run argv' \
				-e 'tell application "Finder" to delete (POSIX file (item 1 of argv) as alias)' \
				-e 'end run' "$abs" >/dev/null
			;;
		trashy) trashy put -- "$f" ;;
		trashcli) trash-put -- "$f" ;;
		esac
	done
	;;

restore)
	case "$backend" in
	finder) open "$HOME/.Trash" ;; # no CLI restore on macOS; drag out or Cmd-Z in Finder
	trashy) trashy restore ;;
	trashcli) trash-restore ;;
	esac
	;;

undo) # restore the most recent item
	case "$backend" in
	trashy) trashy restore -r 0 ;; # your flag; check `trashy restore --help`
	*) "$0" restore ;;
	esac
	;;

empty)
	printf 'Empty the trash permanently? [y/N] '
	read -r ans
	[ "$ans" = y ] || exit 0
	case "$backend" in
	finder) osascript -e 'tell application "Finder" to empty trash' ;;
	trashy) trashy empty --all ;;
	trashcli) trash-empty ;;
	esac
	;;
esac
