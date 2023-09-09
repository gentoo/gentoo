# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RJBS
DIST_VERSION=1.009
inherit perl-module

DESCRIPTION="URLs that refer to things on the CPAN"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-perl/CPAN-DistnameInfo
	virtual/perl-Carp
	dev-perl/URI
"
BDEPEND="
	${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.780.0
"
