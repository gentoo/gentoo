# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-build

DESCRIPTION="A virtual package to choose between gamin and fam"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"

RDEPEND="
	|| (
		>=app-admin/gamin-0.1.10-r1[${MULTILIB_USEDEP}]
		>=app-admin/fam-2.7.0-r6[${MULTILIB_USEDEP}]
	)
"
