# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=ETHER
DIST_VERSION=0.78
inherit perl-module

DESCRIPTION="Fast CGI module"

LICENSE="FastCGI"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND="
	virtual/perl-XSLoader
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
