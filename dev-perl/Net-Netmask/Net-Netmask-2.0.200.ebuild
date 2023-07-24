# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=JMASLAK
DIST_VERSION=2.0002
inherit perl-module

DESCRIPTION="Parse, manipulate and lookup IP network blocks"

SLOT="0"
KEYWORDS="~amd64 arm ~arm64 ~mips ~ppc ~ppc64 ~riscv ~x86"
IUSE="minimal"

RDEPEND="
	!minimal? ( >=dev-perl/AnyEvent-7.140.0 )
	virtual/perl-Carp
	virtual/perl-Exporter
	>=virtual/perl-Math-BigInt-1.999.811
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=dev-perl/Test2-Suite-0.0.111
		>=dev-perl/Test-UseAllModules-0.170.0
	)
"
