# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Libraries to write tests in C, C++ and shell"
HOMEPAGE="https://github.com/jmmv/atf"
SRC_URI="https://github.com/jmmv/atf/releases/download/${P}/${P}.tar.gz"

LICENSE="BSD BSD-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-getopt-solaris.patch )

src_install() {
	default
	rm -r "${ED}"/usr/tests || die
	find "${ED}" -name '*.la' -delete || die
}
