# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=GARU
DIST_VERSION=0.40
inherit perl-module

DESCRIPTION="Colored pretty-print of Perl data structures and objects"

SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/Clone-PP
	dev-perl/File-HomeDir
	dev-perl/Sort-Naturally
"
DEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		dev-perl/DBI
		dev-perl/Capture-Tiny
		dev-perl/YAML-Syck
	)
"
