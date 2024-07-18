# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=REHSACK
DIST_VERSION=1.102
inherit perl-module

DESCRIPTION="Utility functions to aid in parameter checking"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

RDEPEND="
	>=virtual/perl-Scalar-List-Utils-1.180.0
	>=virtual/perl-XSLoader-0.220.0
"
BDEPEND="${RDEPEND}
	>=dev-perl/Config-AutoConf-0.315.0
	test? (
		virtual/perl-Test-Simple
		dev-perl/Test-LeakTrace
	)
"
