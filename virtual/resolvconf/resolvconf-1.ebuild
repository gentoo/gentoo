# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Virtual to select between different resolvconf providers"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86"

RDEPEND="
	|| (
		net-dns/openresolv
		>=sys-apps/systemd-239-r1[resolvconf]
	)"
