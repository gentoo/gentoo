# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=CJM
DIST_VERSION=1.12
inherit perl-module

DESCRIPTION="Getopt::Mixed is used for parsing mixed options"

SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc sparc x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Exporter
"
BDEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.300.0
	test? ( virtual/perl-Test-Simple )
"
