# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SANKO
DIST_VERSION=2.05
inherit perl-module

DESCRIPTION="Facility for creating read-only scalars, arrays, hashes"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"

BDEPEND="
	>=dev-perl/Module-Build-Tiny-0.35.0
	test? ( virtual/perl-Test-Simple )
"
