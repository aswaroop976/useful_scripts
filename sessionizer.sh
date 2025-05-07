#!/usr/bin/env bash

BOOKMARK_FILE="${HOME}/.project_bookmarks"

if [[ ! -f "$BOOKMARK_FILE" ]]; then
	echo "Error: bookmark file not found at $BOOKMARK_FILE" >&2
	exit 1
fi

project_path=$(<"$BOOKMARK_FILE" fzf --prompt="Project> ")

[[ -z "$project_path" ]] && exit 0

# Expand a leading '~' to your home directory
if [[ "$project_path" == ~* ]]; then
  project_path="${project_path/#\~/$HOME}"
fi

session_name=$(basename "$project_path")

if tmux has-session -t "$session_name" 2>/dev/null; then
	tmux attach-session -t "$session_name"
else
	#echo $project_path
	tmux new-session -s "$session_name" -c "$project_path"
fi
