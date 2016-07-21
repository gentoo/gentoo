# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=RJBS
DIST_VERSION=3.05
inherit perl-module

DESCRIPTION="Implementation of the soundex algorithm"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="test minimal"

RDEPEND="
	!minimal? ( dev-perl/Text-Unidecode )
	virtual/perl-if
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
