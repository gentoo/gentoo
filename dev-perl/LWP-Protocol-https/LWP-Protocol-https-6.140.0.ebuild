# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=OALDERS
DIST_VERSION=6.14
inherit perl-module

DESCRIPTION="Provide https support for LWP::UserAgent"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-solaris"

RDEPEND="
	>=dev-perl/IO-Socket-SSL-1.970.0
	>=dev-perl/libwww-perl-6.60.0
	>=dev-perl/Net-HTTP-6
"
BDEPEND="
	${RDEPEND}
	test? (
		dev-perl/Net-SSLeay
		>=dev-perl/Test-Needs-0.2.10
		dev-perl/Test-RequiresInternet
	)
"
