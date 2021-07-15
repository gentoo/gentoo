# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=LKINLEY
DIST_VERSION=0.12
DIST_EXAMPLES=("eg/*")
inherit perl-module

DESCRIPTION="Secure File Transfer Protocol client"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-perl/Math-Int64-0.540.0
	>=dev-perl/Net-SSH-Perl-2.120.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
