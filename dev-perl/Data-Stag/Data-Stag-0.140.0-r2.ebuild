# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=CMUNGALL
DIST_VERSION=0.14
inherit perl-module

DESCRIPTION="Structured Tags datastructures"
HOMEPAGE="http://stag.sourceforge.net/ https://metacpan.org/release/Data-Stag"

SLOT="0"
KEYWORDS="~amd64 x86"

RDEPEND="dev-perl/IO-String"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
