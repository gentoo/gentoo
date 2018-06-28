# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=PHRED
DIST_VERSION=1.03
inherit perl-module

DESCRIPTION="Session data support module for SOAP::Lite"

SLOT="0"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
