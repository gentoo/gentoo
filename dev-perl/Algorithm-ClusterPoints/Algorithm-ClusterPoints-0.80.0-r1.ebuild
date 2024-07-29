# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DIST_AUTHOR=SALVA
DIST_VERSION=0.08
inherit perl-module

DESCRIPTION="Find clusters inside a set of points"
SLOT="0"
KEYWORDS="~amd64 ~x86"
# License note: says 'perl 5.8.8 or any later' bug #718946
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( virtual/perl-Test-Simple )
"
PERL_RM_FILES=(
	"t/pods.t"
)
