# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Standalone fts library for use with musl"
HOMEPAGE="https://github.com/pullmoll/musl-fts"
SRC_URI="https://github.com/pullmoll/musl-fts/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/musl-fts-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~m68k ~mips ppc ppc64 ~riscv x86"
IUSE="static-libs"

DEPEND="
	!sys-libs/glibc"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
	mv "${ED}"/usr/$(get_libdir)/pkgconfig/{musl-fts,fts-standalone}.pc || die
}
