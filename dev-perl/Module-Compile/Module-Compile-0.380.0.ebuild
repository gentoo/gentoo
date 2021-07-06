# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=INGY
DIST_VERSION=0.38
inherit perl-module

DESCRIPTION="Perl Module Compilation"

SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"

RDEPEND="
	dev-perl/Capture-Tiny
	>=dev-perl/Digest-SHA1-2.130.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"

DIST_TEST=do
# parallel testing fails
