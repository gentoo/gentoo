# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Package for preventing processes from using exec system calls"
HOMEPAGE="https://noexec.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="sys-libs/glibc"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	sed -e "/^#define PRELOAD_LIBRARY_PATH/s|/usr/lib|${EPREFIX}/usr/$(get_libdir)|" \
		-i src/noexec_macro.h || die

	eautoreconf #874426
}

src_install() {
	default

	find "${ED}" -type f -name '*.la' -delete || die
}
