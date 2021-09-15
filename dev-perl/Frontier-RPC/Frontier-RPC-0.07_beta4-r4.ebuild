# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_VERSION=0.07b4
DIST_AUTHOR=KMACLEOD
DIST_EXAMPLES=("examples/*")
inherit perl-module

DESCRIPTION="Perform remote procedure calls using extensible markup language"
SRC_URI+=" http://perl-xml.sourceforge.net/xml-rpc/${PN}-${DIST_VERSION}.tar.gz"

SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	dev-perl/HTTP-Daemon
	dev-perl/XML-Parser
	dev-perl/libwww-perl
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
