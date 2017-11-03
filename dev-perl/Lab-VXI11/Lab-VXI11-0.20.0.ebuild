# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_VERSION=0.02
DIST_AUTHOR=AMBA
KEYWORDS="~amd64 ~x86"
inherit perl-module

DESCRIPTION="Perl interface to the VXI-11 Test&Measurement backend"

SLOT="0"

RDEPEND=""
DEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
