# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

MODS="apcupsd"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for apcupsd"

if [[ ${PV} != 9999* ]] ; then
	KEYWORDS="amd64 arm arm64 x86"
fi
DEPEND="${DEPEND}
	sec-policy/selinux-apache
"
RDEPEND="${RDEPEND}
	sec-policy/selinux-apache
"
