# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RCAPUTO
DIST_VERSION=1.023
inherit perl-module

DESCRIPTION="Bind lexicals to persistent data"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"

RDEPEND="
	>=dev-perl/PadWalker-1.960.0
	>=dev-perl/Devel-LexAlias-0.50.0
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? (
		>=virtual/perl-Carp-1.260.0
		>=virtual/perl-Scalar-List-Utils-1.290.0
		>=virtual/perl-Test-Simple-0.980.0
	)
"

PERL_RM_FILES=( "t/02_pod.t" "t/03_pod_coverage.t" "t/release-pod-coverage.t" "t/release-pod-syntax.t" )
