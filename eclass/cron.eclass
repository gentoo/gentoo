# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: cron.eclass
# @MAINTAINER:
# maintainer-needed@gentoo.org
# @AUTHOR:
# Original Author: Aaron Walker <ka0ttic@gentoo.org>
# @SUPPORTED_EAPIS: 6 7
# @BLURB: Some functions for cron
# @DESCRIPTION:
# Purpose: The main motivation for this eclass was to simplify
# the jungle known as ``src_install()`` in cron ebuilds. Using these
# functions also ensures that permissions are *always* reset,
# preventing the accidental installation of files with wrong perms.
#
# NOTE on defaults: the default settings in the below functions were
# chosen based on the most common setting among cron ebuilds.

case ${EAPI} in
	[67]) inherit eutils ;;
	*) die "EAPI=${EAPI:-0} is not supported" ;;
esac

inherit flag-o-matic

EXPORT_FUNCTIONS pkg_postinst

if [[ -z ${_CRON_ECLASS} ]]; then
_CRON_ECLASS=1

SLOT="0"

RDEPEND=">=sys-process/cronbase-0.3.2"
for pn in vixie-cron bcron cronie dcron fcron; do
	[[ ${pn} == "${PN}" ]] || RDEPEND="${RDEPEND} !sys-process/${pn}"
done

# @FUNCTION: docrondir
# @USAGE: [ dir ] [ perms ]
# @DESCRIPTION:
# Creates crontab directory
#
# Both arguments are optional.  Everything after ``dir`` is considered
# the permissions (same format as ``insopts``).
#
# Example:
# @CODE
# 	docrondir /some/dir -m 0770 -o 0 -g cron
# 	docrondir /some/dir (uses default perms)
# 	docrondir -m0700 (uses default dir)
# @CODE
docrondir() {
	# defaults
	local perms="-m0750 -o 0 -g cron" dir="/var/spool/cron/crontabs"

	if [[ -n $1 ]] ; then
		case "$1" in
			*/*)
				dir=$1
				shift
				[[ -n $1 ]] && perms="$@"
				;;
			*)
				perms="$@"
				;;
		esac
	fi

	diropts ${perms}
	keepdir ${dir}

	# reset perms to default
	diropts -m0755
}

# @FUNCTION: docron
# @USAGE: [ exe ] [ perms ]
# @DESCRIPTION:
# Install cron executable
#
# Both arguments are optional.
#
# Example:
# @CODE
# 	docron -m 0700 -o 0 -g root # 'exe' defaults to "cron"
# 	docron crond -m 0110
# @CODE
docron() {
	local cron="cron" perms="-m 0750 -o 0 -g wheel"

	if [[ -n $1 ]] ; then
		case "$1" in
			-*)
				perms="$@"
				;;
			 *)
				cron=$1
				shift
				[[ -n $1 ]] && perms="$@"
				;;
		esac
	fi

	exeopts ${perms}
	exeinto /usr/sbin
	doexe ${cron} || die "failed to install ${cron}"

	# reset perms to default
	exeopts -m0755
}

# @FUNCTION: docrontab
# @USAGE: [ exe ] [ perms ]
# @DESCRIPTION:
# Install crontab executable
#
# Uses same semantics as ``docron``.
docrontab() {
	local crontab="crontab" perms="-m 4750 -o 0 -g cron"

	if [[ -n $1 ]] ; then
		case "$1" in
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

	exeopts ${perms}
	exeinto /usr/bin
	doexe ${crontab} || die "failed to install ${crontab}"

	# reset perms to default
	exeopts -m0755

	# users expect /usr/bin/crontab to exist...
	if [[ "${crontab##*/}" != "crontab" ]] ; then
		dosym ${crontab##*/} /usr/bin/crontab || \
			die "failed to create /usr/bin/crontab symlink"
	fi
}

# @FUNCTION: cron_pkg_postinst
# @DESCRIPTION:
# Outputs a message about system crontabs.
#
# Daemons that have a true system crontab set ``CRON_SYSTEM_CRONTAB="yes"``.
cron_pkg_postinst() {
	echo
	#  daemons that have a true system crontab set CRON_SYSTEM_CRONTAB="yes"
	if [ "${CRON_SYSTEM_CRONTAB:-no}" != "yes" ] ; then
		einfo "To activate /etc/cron.{hourly|daily|weekly|monthly} please run:"
		einfo " crontab /etc/crontab"
		einfo
		einfo "!!! That will replace root's current crontab !!!"
		einfo
	fi

	einfo "You may wish to read the Gentoo Linux Cron Guide, which can be"
	einfo "found online at:"
	einfo "    https://wiki.gentoo.org/wiki/Cron"
	echo
}

fi
