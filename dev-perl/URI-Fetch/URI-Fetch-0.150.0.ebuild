# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=NEILB
DIST_VERSION=0.15
inherit perl-module

DESCRIPTION="Smart URI fetching/caching"

SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv ~x86"

RDEPEND="
	virtual/perl-Carp
	dev-perl/Class-ErrorHandler
	dev-perl/libwww-perl
	virtual/perl-Storable
	dev-perl/URI
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Data-Dumper
		virtual/perl-Test-Simple
		>=dev-perl/Test-RequiresInternet-0.50.0
	)
"
