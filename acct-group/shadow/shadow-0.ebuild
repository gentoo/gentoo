# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-group user-info

ACCT_GROUP_ID=42

pkg_postinst() {
	# Look up the gid in ${EROOT}/etc/group.
	# It may differ from the gid in /etc/group.
	local gid=$(egetent group shadow | cut -d: -f3)
	if [[ -z ${gid} ]]; then
		eerror "Unable to determine id for shadow group"
		return
	fi
	local db
	for db in gshadow shadow; do
		[[ -e ${EROOT}/etc/${db} ]] || continue
		chgrp "${gid}" "${EROOT}/etc/${db}"
		chmod g+r "${EROOT}/etc/${db}"
	done
}
