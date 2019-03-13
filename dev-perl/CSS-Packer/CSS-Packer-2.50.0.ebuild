# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
DIST_AUTHOR=LEEJO
DIST_VERSION=2.05
inherit perl-module

DESCRIPTION="Another CSS minifier"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	>=dev-perl/Regexp-RegGrp-1.1.1_rc
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Test-File-Contents
		virtual/perl-Test-Simple
	)
"
PERL_RM_FILES=( "t/pod.t" )
