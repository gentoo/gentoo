# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=APERSAUD
DIST_VERSION=1.37
DIST_EXAMPLES=( "tools/*" )
inherit perl-module

DESCRIPTION="Parse nmap scan data with perl"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=virtual/perl-Storable-2.0.0
	>=dev-perl/XML-Twig-3.160.0"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
