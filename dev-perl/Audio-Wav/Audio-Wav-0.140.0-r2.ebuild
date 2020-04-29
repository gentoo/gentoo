# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=BRIANSKI
DIST_VERSION=0.14
inherit perl-module

DESCRIPTION="Modules for reading & writing Microsoft WAV files"

SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"

RDEPEND="
	>=dev-perl/Inline-0.790.0
	dev-perl/Inline-C
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
