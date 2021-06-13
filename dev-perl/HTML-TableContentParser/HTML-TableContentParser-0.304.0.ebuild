# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=WYANT
DIST_VERSION=0.304
inherit perl-module

DESCRIPTION="Do interesting things with the contents of tables"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	virtual/perl-Carp
	dev-perl/HTML-Parser
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
