# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
MODULE_AUTHOR=LEEJO
MODULE_VERSION=2.00
inherit perl-module

DESCRIPTION='Groups a regular expressions collection'
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.560.0
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST="do"

# Dubious tes.t
PERL_RM_FILES=(
	t/01-data.t
)
