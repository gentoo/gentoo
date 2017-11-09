# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DSCHWEI
DIST_VERSION=1.12
inherit perl-module

DESCRIPTION="A grammar-based, user-friendly config parser"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~sparc ~x86"
IUSE="test"

RDEPEND=""
DEPEND="virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test
		virtual/perl-Test-Simple
	)
"
PERL_RM_FILES=(
	"lib/Config/Grammar.pm~"
)
