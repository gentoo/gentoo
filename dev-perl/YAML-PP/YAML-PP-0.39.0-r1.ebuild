# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TINITA
DIST_VERSION=v${PV}
inherit perl-module

DESCRIPTION="YAML 1.2 processor in perl"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

RDEPEND="
	>=virtual/perl-Scalar-List-Utils-1.70.0
"
BDEPEND="
	${RDEPEND}
	test? (
		>=virtual/perl-Test-Simple-0.980.0
		dev-perl/Test-Warn
	)
"
