# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MODS="hadoop"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for hadoop"

if [[ ${PV} != 9999* ]] ; then
	KEYWORDS="amd64 arm arm64 x86"
fi
