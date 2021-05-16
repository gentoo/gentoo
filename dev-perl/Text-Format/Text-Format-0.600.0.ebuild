# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=SHLOMIF
DIST_VERSION=0.60

inherit perl-module

DESCRIPTION="Various subroutines to format text"

SLOT="0"
KEYWORDS="amd64 x86"

IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="virtual/perl-Carp"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? ( virtual/perl-Test-Simple )
"
PERL_RM_FILES=( "t/pod-coverage.t" "t/cpan-changes.t" "t/pod.t" "t/style-trailing-space.t" )
