# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=INGY
DIST_VERSION=0.35
inherit perl-module

DESCRIPTION="Perl Module Compilation"

SLOT="0"
KEYWORDS="~amd64 arm ppc ~x86"
IUSE=""

RDEPEND="
	>=dev-perl/Digest-SHA1-2.130.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
"

DIST_TEST=do
# parallel testing fails
