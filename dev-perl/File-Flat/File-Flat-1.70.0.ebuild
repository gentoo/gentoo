# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=ETHER
DIST_VERSION=1.07
inherit perl-module

DESCRIPTION="Implements a flat filesystem"

SLOT="0"
KEYWORDS="amd64 ~hppa ~mips ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-perl/File-Copy-Recursive-0.350.0
	>=dev-perl/File-Remove-0.380.0
	>=virtual/perl-File-Spec-0.850.0
	>=virtual/perl-File-Temp-0.170.0
	virtual/perl-IO
	>=dev-perl/prefork-0.20.0
"
BDEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-CPAN-Meta-2.120.900
		>=dev-perl/Test-ClassAPI-1.40.0
		>=virtual/perl-Test-Simple-0.470.0
	)
"
