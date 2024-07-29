# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SMUELLER
DIST_VERSION=1.05
inherit perl-module

DESCRIPTION="Set of useful typemaps"

SLOT="0"
KEYWORDS="~amd64 x86"

RDEPEND="
	>=virtual/perl-ExtUtils-ParseXS-3.180.300
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.400.0
	test? ( virtual/perl-Test-Simple )
"
