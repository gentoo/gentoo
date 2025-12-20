# Copyright 2017-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Libraries to write tests in C, C++ and shell"
HOMEPAGE="https://github.com/freebsd/atf"
SRC_URI="https://github.com/freebsd/atf/archive/refs/tags/${P}.tar.gz"
S="${WORKDIR}/atf-${P}"

LICENSE="BSD BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos ~x64-solaris"

BDEPEND="virtual/pkgconfig"

PATCHES=(
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myconf=(
		ATF_SHELL="${EPREFIX}/bin/sh"
	)
	econf "${myconf[@]}"
}

src_install() {
	default
	rm -r "${ED}"/usr/tests || die
	find "${ED}" -name '*.la' -delete || die
}
