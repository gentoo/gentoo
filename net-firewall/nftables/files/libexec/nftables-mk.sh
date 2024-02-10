#!/bin/sh

main() {
	local NFTABLES_SAVE=${2:-'/var/lib/nftables/rules-save'}
	case "$1" in
		"check")
			nft -c -f "${NFTABLES_SAVE}"
		;;
		"clear")
			nft flush ruleset
		;;
		"list")
			nft ${SAVE_OPTIONS} list ruleset
		;;
		"load")
			# We use an include because cat fails with long rulesets see #675188
			printf 'flush ruleset\ninclude "%s"\n' "${NFTABLES_SAVE}" | nft -f -
		;;
		"panic")
			panic hard | nft -f -
		;;
		"soft_panic")
			panic soft | nft -f -
		;;
		"store")
			local tmp_save="${NFTABLES_SAVE}.tmp"
			umask 177
			(
				printf '#!/sbin/nft -f\nflush ruleset\n'
				nft ${SAVE_OPTIONS} list ruleset
			) > "$tmp_save" && mv ${tmp_save} ${NFTABLES_SAVE}
		;;
	esac
}

panic() {
	local erule;
	[ "$1" = soft ] && erule="ct state established,related accept;" || erule="";
	cat <<EOF
flush ruleset
table inet filter {
	chain input {
		type filter hook input priority 0;
		$erule
		drop
	}
	chain forward {
		type filter hook forward priority 0;
		drop
	}
	chain output {
		type filter hook output priority 0;
		$erule
		drop
	}
}
EOF
}

main "$@"
