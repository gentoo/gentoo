# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RJBS
DIST_VERSION=1.007
inherit perl-module

DESCRIPTION="URLs that refer to things on the CPAN"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-perl/CPAN-DistnameInfo
	virtual/perl-Carp
	dev-perl/URI
"
BDEPEND="${RDEPEND}
"
