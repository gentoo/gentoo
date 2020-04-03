# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils toolchain-funcs fortran-2

DESCRIPTION="High quality system independent, open source libm"
HOMEPAGE="https://github.com/JuliaLang/openlibm"
SRC_URI="https://codeload.github.com/JuliaMath/openlibm/tar.gz/v${PV} -> ${P}.tar.gz"

LICENSE="public-domain MIT ISC BSD-2 LGPL-2.1+"
SLOT="0/${PV}.0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

IUSE="static-libs"

src_install() {
	emake DESTDIR="${D}" prefix="${EPREFIX}/usr" \
		libdir="${EPREFIX}/usr/$(get_libdir)" install
	use static-libs || rm "${D}/${EPREFIX}/usr/$(get_libdir)/libopenlibm.a" || die "rm failed"
	dodoc README.md
}
