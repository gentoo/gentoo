# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MONS
DIST_VERSION=0.17
inherit perl-module

DESCRIPTION="Simple and very fast XML to hash conversion"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="virtual/perl-Encode"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker"
