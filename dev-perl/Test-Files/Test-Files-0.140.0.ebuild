# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=PHILCROW
DIST_VERSION=0.14
inherit perl-module

DESCRIPTION="A Test::Builder based module to ease testing with files and dirs"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-perl/Algorithm-Diff
	virtual/perl-Test-Simple
	dev-perl/Text-Diff
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
