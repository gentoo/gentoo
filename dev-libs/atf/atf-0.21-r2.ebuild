# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="Libraries to write tests in C, C++ and shell"
HOMEPAGE="https://github.com/freebsd/atf"
SRC_URI="https://github.com/freebsd/atf/releases/download/${P}/${P}.tar.gz"

LICENSE="BSD BSD-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~ppc-macos ~x64-macos ~x64-solaris"

BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-getopt-solaris.patch )

src_prepare() {
	default
	eautoreconf # 879659

	# Uses std::auto_ptr (deprecated in c++11, removed in c++17)
	append-cxxflags "-std=c++14"
}

src_install() {
	default
	rm -r "${ED}"/usr/tests || die
	find "${ED}" -name '*.la' -delete || die
}
