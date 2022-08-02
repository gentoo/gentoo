# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PEVANS
DIST_VERSION=0.27
inherit perl-module

DESCRIPTION="a try/catch/finally syntax for Perl"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-perl/XS-Parse-Keyword"
BDEPEND="${RDEPEND}
	dev-perl/Module-Build
	dev-perl/XS-Parse-Keyword
	virtual/perl-ExtUtils-CBuilder"
