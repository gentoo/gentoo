# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="ANSI C command-line parsing library based on getopt"
HOMEPAGE="https://www.argtable.org/"
SRC_URI="https://github.com/argtable/${PN}/releases/download/v${PV}/argtable-v${PV}.tar.gz"
S="${WORKDIR}/argtable-v${PV}"

# Their LICENSE file is a concatenation; thus is our variable:
#
#   * argtable3 itself: BSD
#   * FreeBSD getopt: BSD-2
#   * TCL/TK: tcltk
#   * Hash table: BSD
#   * Better string: BSD
#
LICENSE="BSD BSD-2 tcltk"

SLOT="0"
KEYWORDS="~amd64 ~riscv"
IUSE="examples test"
RESTRICT="!test? ( test )"

src_configure() {
	local mycmakeargs=(
		-DARGTABLE3_ENABLE_TESTS=$(usex test)
		-DARGTABLE3_ENABLE_EXAMPLES=OFF  # don't _build_ the examples
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	if use examples; then
		docinto examples
		dodoc examples/*.c
		dodoc -r examples/multicmd
	fi
}
