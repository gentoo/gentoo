# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=EVO
DIST_VERSION=2010.002
inherit perl-module

DESCRIPTION="Backslash escapes, quoted phrase, word elision, etc"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"
PERL_RM_FILES=( "t/91-pod.t" "t/92-pod-coverage.t" )
