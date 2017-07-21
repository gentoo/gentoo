# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=APERSAUD
DIST_VERSION=1.34
inherit perl-module

DESCRIPTION="Parse nmap scan data with perl"
HOMEPAGE="http://nmapparser.wordpress.com/ https://code.google.com/p/nmap-parser/ ${HOMEPAGE}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="virtual/perl-Storable
	>=dev-perl/XML-Twig-3.160.0"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
