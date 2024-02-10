# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: cron.eclass
# @MAINTAINER:
# maintainer-needed@gentoo.org
# @AUTHOR:
# Original Author: Aaron Walker <ka0ttic@gentoo.org>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: Some functions for cron
# @DESCRIPTION:
# Purpose: The main motivation for this eclass was to simplify
# the jungle known as src_install() in cron ebuilds.  Using these
# functions also ensures that permissions are *always* reset,
# preventing the accidental installation of files with wrong perms.
#
# NOTE on defaults: the default settings in the below functions were
# chosen based on the most common setting among cron ebuilds.

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_CRON_ECLASS} ]]; then
_CRON_ECLASS=1

inherit flag-o-matic

RDEPEND=">=sys-process/cronbase-0.3.2"
for pn in bcron cronie dcron fcron; do
	[[ ${pn} == "${PN}" ]] || RDEPEND+=" !sys-process/${pn}"
done
unset pn

# @FUNCTION: docrondir
# @USAGE: [dir] [perms]
# @DESCRIPTION:
# Creates crontab directory
#
#	Both arguments are optional.  Everything after 'dir' is considered
#   the permissions (same format as insopts).
#
# ex: docrondir /some/dir -m 0770 -o 0 -g cron
#     docrondir /some/dir (uses default perms)
#     docrondir -m0700 (uses default dir)
docrondir() {
	# defaults
	local perms="-m0750 -o 0 -g cron"
	local dir="/var/spool/cron/crontabs"

	if [[ -n $1 ]] ; then
		case $1 in
			*/*)
				dir="$1"
				shift
				[[ -n $1 ]] && perms="$@"
				;;
			*)
				perms="$@"
				;;
		esac
	fi

	(
		diropts ${perms}
		keepdir ${dir}
	)
}

# @FUNCTION: docron
# @USAGE: [exe] [perms]
# @DESCRIPTION:
# Install cron executable
#
#    Both arguments are optional.
#
# ex: docron -m 0700 -o 0 -g root ('exe' defaults to "cron")
#     docron crond -m 0110
docron() {
	local cron="cron"
	local perms="-m 0750 -o 0 -g wheel"

	if [[ -n $1 ]] ; then
		case $1 in
			-*)
				perms="$@"
				;;
			 *)
				cron="$1"
				shift
				[[ -n $1 ]] && perms="$@"
				;;
		esac
	fi

	(
		exeopts ${perms}
		exeinto /usr/sbin
		doexe ${cron}
	)
}

# @FUNCTION: docrontab
# @USAGE: [exe] [perms]
# @DESCRIPTION:
# Install crontab executable
#
#   Uses same semantics as docron.
docrontab() {
	local crontab="crontab"
	local perms="-m 4750 -o 0 -g cron"

	if [[ -n $1 ]] ; then
		case $1 in
			-*)
				perms="$@"
				;;
			 *)
				crontab=$1
				shift
				[[ -n $1 ]] && perms="$@"
				;;
		esac
	fi

	(
		exeopts ${perms}
		exeinto /usr/bin
		doexe ${crontab}
	)

	# users expect /usr/bin/crontab to exist...
	if [[ ${crontab##*/} != crontab ]] ; then
		dosym ${crontab##*/} /usr/bin/crontab || \
			die "failed to create /usr/bin/crontab symlink"
	fi
}

# @FUNCTION: cron_pkg_postinst
# @DESCRIPTION:
# Outputs a message about system crontabs
# daemons that have a true system crontab set CRON_SYSTEM_CRONTAB="yes"
cron_pkg_postinst() {
	#  daemons that have a true system crontab set CRON_SYSTEM_CRONTAB="yes"
	if [[ ${CRON_SYSTEM_CRONTAB:-no} != yes ]] ; then
		einfo "To activate /etc/cron.{hourly|daily|weekly|monthly} please run:"
		einfo " crontab /etc/crontab"
		einfo
		einfo "!!! That will replace root's current crontab !!!"
		einfo
	fi

	einfo "You may wish to read the Gentoo Linux Cron Guide, which can be"
	einfo "found online at:"
	einfo "    https://wiki.gentoo.org/wiki/Cron"
}

fi

EXPORT_FUNCTIONS pkg_postinst
