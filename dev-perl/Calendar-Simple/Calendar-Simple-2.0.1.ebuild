# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=DAVECROSS
DIST_VERSION=v2.0.1
inherit perl-module

DESCRIPTION="Perl extension to create simple calendars"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"
IUSE="minimal test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Time-Local
	!minimal? (
		dev-perl/DateTime
	)
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.420.0
	test? ( virtual/perl-Test-Simple )
"

PERL_RM_FILES=( "t/pod_coverage.t" "t/pod.t" )
