# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ANDK
DIST_VERSION=2.18
inherit perl-module

DESCRIPTION="Dump symbol names or the symbol table"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

PERL_RM_FILES=(
	t/podcover.t
	t/pod.t
)
