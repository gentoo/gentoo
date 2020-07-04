# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DAVECROSS
DIST_VERSION=1.23
inherit perl-module

DESCRIPTION="Perl extension to create simple calendars"

SLOT="0"
KEYWORDS="amd64 ~hppa ~ppc x86 ~ppc-aix"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Time-Local
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.28
	test? ( virtual/perl-Test-Simple )
"

PERL_RM_FILES=( "t/pod_coverage.t" "t/pod.t" )
