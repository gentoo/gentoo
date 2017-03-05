# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=LBROCARD
DIST_VERSION=0.31
inherit perl-module

DESCRIPTION="Provide a progress meter if run interactively"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="
	dev-perl/IO-Interactive
	dev-perl/Term-ProgressBar
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/Test-MockObject
		virtual/perl-Test-Simple
	)
"
