# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A standalone library to implement GNU libc's obstack"
HOMEPAGE="https://github.com/void-linux/musl-obstack"
SRC_URI="https://github.com/void-linux/musl-obstack/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/musl-obstack-${PV}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~m68k ~mips ppc ppc64 ~riscv x86"
IUSE="static-libs"

DEPEND="!sys-libs/glibc"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
	mv "${ED}"/usr/$(get_libdir)/pkgconfig/{musl-obstack,obstack-standalone}.pc || die
}
