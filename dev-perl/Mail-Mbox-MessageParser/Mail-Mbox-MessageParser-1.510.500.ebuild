# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=DCOPPIT
MODULE_VERSION=1.5105
inherit perl-module

DESCRIPTION="A fast and simple mbox folder reader"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="test"

RDEPEND="
	dev-perl/FileHandle-Unget
	virtual/perl-Storable
	dev-perl/File-Slurp
	dev-perl/URI
	dev-perl/Text-Diff
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.360.0
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST="do parallel"
