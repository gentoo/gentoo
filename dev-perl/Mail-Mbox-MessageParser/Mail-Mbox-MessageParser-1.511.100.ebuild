# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DCOPPIT
DIST_VERSION=1.5111
inherit perl-module

DESCRIPTION="A fast and simple mbox folder reader"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	dev-perl/FileHandle-Unget
	virtual/perl-Storable
	dev-perl/File-Slurper
	dev-perl/URI
	dev-perl/Text-Diff
	dev-perl/UNIVERSAL-require
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.360.0
	test? (
		virtual/perl-Test-Simple
		dev-perl/Test-Compile
	)
"
