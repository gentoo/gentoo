# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=LEONT
DIST_VERSION=0.001
inherit perl-module

DESCRIPTION="Dynamic prerequisites in meta files"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	dev-perl/CPAN-Meta-Requirements
	dev-perl/ExtUtils-Config
	dev-perl/ExtUtils-HasCompiler
"
