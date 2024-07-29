# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual for net-misc/openssh and variants"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="ssl"

RDEPEND="
	|| (
		>=net-misc/openssh-9.3_p1-r1[ssl?]
		>=net-misc/openssh-contrib-9.3_p1[ssl?]
	)"
