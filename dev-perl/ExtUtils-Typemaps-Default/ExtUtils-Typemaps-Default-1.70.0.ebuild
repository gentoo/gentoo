# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SMUELLER
DIST_VERSION=1.07
inherit perl-module

DESCRIPTION="Set of useful typemaps"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=virtual/perl-ExtUtils-ParseXS-3.210.000
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.420.0
"
