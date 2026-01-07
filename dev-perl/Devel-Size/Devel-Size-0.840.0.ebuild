# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=NWCLARK
DIST_VERSION=0.84
inherit perl-module

DESCRIPTION="Perl extension for finding the memory usage of Perl variables"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv x86 ~x64-macos"

src_compile() {
	mymake=(
		"OPTIMIZE=${CFLAGS}"
	)
	perl-module_src_compile
}
