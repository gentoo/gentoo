# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=OVID
DIST_VERSION=0.38
inherit perl-module

DESCRIPTION="Most commonly needed test functions and features"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND="
	>=dev-perl/Exception-Class-1.140.0
	>=dev-perl/Test-Deep-0.119.0
	>=dev-perl/Test-Differences-0.640.0
	>=dev-perl/Test-Exception-0.430.0
	>=virtual/perl-Test-Harness-3.350.0
	>=virtual/perl-Test-Simple-1.302.47
	>=dev-perl/Test-Warn-0.300.0
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
