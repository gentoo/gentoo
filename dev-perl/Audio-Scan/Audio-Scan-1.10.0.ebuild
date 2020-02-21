# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=AGRUNDMA
DIST_VERSION=1.01
inherit perl-module

DESCRIPTION="Fast C metadata and tag reader for all common audio file formats"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Test-Warn
	)
"
PERL_RM_FILES=( "t/02pod.t" "t/03podcoverage.t" "t/04critic.t" )
