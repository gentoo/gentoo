# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RUZ
DIST_VERSION=1.54
inherit perl-module

DESCRIPTION="Perl5 module to create charts using the GD module"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86 ~x86-solaris"

RDEPEND="
	>=dev-perl/GD-1.180.0
	>=dev-perl/GDTextUtil-0.800.0
	media-libs/gd
"
DEPEND="${RDEPEND}
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.760.0
	test? (
		>=dev-perl/Capture-Tiny-0.300.0
		>=dev-perl/Test-Exception-0.400.0
		>=virtual/perl-Test-Simple-0.880.0
	)
"
