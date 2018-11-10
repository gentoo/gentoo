# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DBROBINS
DIST_VERSION=0.10
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="Secure File Transfer Protocol client"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=dev-perl/Net-SSH-Perl-1.240.0"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker"
