# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=NEILB
DIST_VERSION=1.05
inherit perl-module

DESCRIPTION="Convert cardinal numbers(3) to ordinal numbers(3rd)"

SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ppc sparc x86"

RDEPEND="
	virtual/perl-Exporter
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( >=virtual/perl-Test-Simple-0.880.0 )
"
