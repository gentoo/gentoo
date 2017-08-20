# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=OLIMAUL
# https://rt.cpan.org/Ticket/Display.html?id=120669
DIST_VERSION=0.22.2
inherit perl-module
S="${WORKDIR}/${PN}-0.22"

DESCRIPTION="Generic CRC function"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
