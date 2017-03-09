# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=DCOPPIT
MODULE_VERSION=0.7107
inherit perl-module

DESCRIPTION="Perl code benchmarking tool"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-perl/Statistics-TTest
	virtual/perl-Time-HiRes
"

DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.360.0
	test? ( virtual/perl-Test-Simple )
"

SRC_TEST=do
