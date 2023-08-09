# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user user-info

ACCT_USER_ID=452
ACCT_USER_HOME=/var/lib/vdr
ACCT_USER_GROUPS=( vdr audio cdrom video )

DESCRIPTION="VDR (VideoDiskRecorder) service user"
IUSE="graphlcd legacy-homedir remote serial systemd"

acct-user_add_deps

pkg_setup() {
	# if user wants to preserve his existing vdr installation,
	# he can set USE=legacy-homedir
	use legacy-homedir && ACCT_USER_HOME=/var/vdr

	# media-plugins/vdr-graphlcd
	use graphlcd && ACCT_USER_GROUPS+=( lp usb )

	# media-plugins/vdr-remote, _only_ when systemd is installed
	if use remote; then
		if use systemd; then
			ACCT_USER_GROUPS+=( input )
		else
			einfo "use-flag remote has no effect on systemd systems"
		fi
	fi

	# media-plugins/vdr-serial: add group to access /dev/ttyS*
	# on systemd systems: add "dialout"
	# non-systemd systems: add "uucp"
	if use serial; then
		if use systemd; then
			ACCT_USER_GROUPS+=( dialout )
		else
			ACCT_USER_GROUPS+=( uucp )
		fi
	fi
}

pkg_preinst() {
	# if useflag legacy-homedir is _not_ set, check if user vdr exists and what his homedir is
	if ! use legacy-homedir; then
		local EXISTING_HOME=$(egethome vdr)
		if [[ "${EXISTING_HOME}" = "/var/vdr" ]]; then
			ewarn "The user \"vdr\" exists on this system, his current home directory is \"/var/vdr\""
			ewarn "The new default home directory for user vdr is \"/var/lib/vdr\""
			ewarn "You have three options to continue:"
			ewarn " - set USE=legacy-homedir for ${CATEGORY}/${PN} to continue to use /var/vdr"
			ewarn " - move /var/vdr to /var/lib/vdr manually and repeat to install ${CATEGORY}/${PN}"
			ewarn " - move /var/vdr to /var/vdr.old or anywhere else (to keep it as your backup), repeat to"
			ewarn "   install ${CATEGORY}/${PN} and let the installation create a fresh /var/lib/vdr"
			ewarn "the emerge will stop here."
			die "user action required"
		fi
	fi
	acct-user_pkg_preinst
}
