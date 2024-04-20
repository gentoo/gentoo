#!/usr/bin/env bash
# vim: ts=4 sw=4 noet ft=sh
#
# Example script to process Fangfrisch News.

declare -r MAILFROM="noreply"
declare -r MAILTO="alice@example.com"
declare -r SUBJECT="Fangfrisch News are available"

# Pick one of the following options and uncomment the 'declare'
# statements. Otherwise, the script will not run otherwise.

# Option 1: Mutt
#declare -r MAILAPP="mutt"
#declare -r MAILAPP_OPT=( "-s" "$SUBJECT" "$MAILTO" )

# Option 2: sendmail
#declare -r MAILAPP="sendmail"
#declare -r MAILAPP_OPT=( "-t" )
#export PATH="$PATH:/usr/sbin"

# Option 3: swaks
#declare -r MAILAPP="swaks"
#declare -r MAILAPP_OPT=( "-d" "-" "-f" "$MAILFROM" "-t" "$MAILTO" )

### No changes required below this line ###

set -euo pipefail

die() {
	echo >&2 "$@"
	exit 1
}

usage() {
	die "Usage: $(basename "$0") {directory}"
}

gen_header() {
	cat <<EOT
From: Fangfrisch News <$MAILFROM>
To: $MAILTO
Subject: $SUBJECT

EOT
# Mail header must end with an empty line!
}

declare -a NEWSITEMS=()

report_news() {
	local dir=$1 ni
	[ -d "$dir" ] || die "$dir is not a directory"
	while IFS= read -r -d '' ni; do
		if [ ${#NEWSITEMS[*]} -eq 0 ] && [ "$MAILAPP" != mutt ]; then
			# Mutt does not need the header, others do.
			gen_header
		fi
		NEWSITEMS+=( "$ni" )
		echo -e "\n### $(basename "$ni"):\n"
		cat "$ni"
	done < <(find "$dir" -maxdepth 1 -type f -name "fangfrisch*.txt" -print0)
}

main() {
	local t
	[ -n "$MAILAPP" ] || die "MAILAPP is undefined, exiting."
	if tty -s; then
		# Running in a terminal session
		t=$(mktemp)
		# shellcheck disable=SC2064
		trap "rm $t" EXIT
		report_news "$@" | tee "$t" || exit 1
		[ ! -s "$t" ] || "$MAILAPP" "${MAILAPP_OPT[@]}" >/dev/null <"$t"
	else
		report_news "$@" 2>&1 | "$MAILAPP" "${MAILAPP_OPT[@]}" >/dev/null
		[ ${#NEWSITEMS[*]} -eq 0 ] || rm -v "${NEWSITEMS[@]}"
	fi
}

[ $# -ge 1 ] || usage
main "$@"
