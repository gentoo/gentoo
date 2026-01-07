# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TODDR
DIST_VERSION=1.34
inherit perl-module toolchain-funcs

DESCRIPTION="Fast, lightweight YAML loader and dumper"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"

src_configure() {
	export CC="$(tc-getCC) -std=gnu17"

	perl-module_src_configure
}
