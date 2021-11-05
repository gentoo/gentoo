# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=LDS
DIST_VERSION=1.09
inherit perl-module

DESCRIPTION="Perl extension for access to network card configuration information"

SLOT="0"
KEYWORDS="~alpha amd64 ppc ~ppc64 x86"

RDEPEND="
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.420.0
	virtual/perl-ExtUtils-CBuilder
"
