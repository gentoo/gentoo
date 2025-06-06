# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=JMASLAK
DIST_VERSION=2.0003
inherit perl-module

DESCRIPTION="Parse, manipulate and lookup IP network blocks"

SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="minimal"

RDEPEND="
	!minimal? ( >=dev-perl/AnyEvent-7.140.0 )
	>=virtual/perl-Math-BigInt-1.999.811
"
BDEPEND="
	${RDEPEND}
	test? (
		>=virtual/perl-Test2-Suite-0.0.111
		>=dev-perl/Test-UseAllModules-0.170.0
	)
"
