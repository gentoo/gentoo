# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=OALDERS
DIST_VERSION=6.24
inherit perl-module

DESCRIPTION="Low-level HTTP connection (client)"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-solaris"
IUSE="minimal"

RDEPEND="
	!<dev-perl/libwww-perl-6
	dev-perl/URI
	!minimal? (
		dev-perl/IO-Socket-INET6
		>=dev-perl/IO-Socket-SSL-2.12.0
	)
"
