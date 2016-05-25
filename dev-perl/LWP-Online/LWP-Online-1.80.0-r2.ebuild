# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
DIST_AUTHOR=ADAMK
DIST_VERSION=1.08
inherit perl-module

DESCRIPTION="Does your process have access to the web"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~x86"
IUSE="test"
# https://rt.cpan.org/Public/Bug/Display.html?id=112728
PATCHES=("${FILESDIR}/${DIST_VERSION}-no-network.patch")
# LWP::Simple -> libwww-perl
RDEPEND="
	>=dev-perl/libwww-perl-5.805.0
	>=dev-perl/URI-1.350.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.420.0
	test? ( >=virtual/perl-Test-Simple-0.420.0 )
"
