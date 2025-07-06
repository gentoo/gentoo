# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DMUEY
DIST_VERSION=0.45
inherit perl-module

DESCRIPTION="uses File::Copy to recursively copy dirs"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

BDEPEND="
	test? (
		dev-perl/Path-Tiny
		dev-perl/Test-Deep
		dev-perl/Test-Fatal
		dev-perl/Test-File
		>=virtual/perl-Test-Simple-0.880.0
		dev-perl/Test-Warnings
	)
"
