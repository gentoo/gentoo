# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs

DESCRIPTION="zstd fast compression library"
HOMEPAGE="http://facebook.github.io/zstd/"
SRC_URI="https://github.com/facebook/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

PATCHES=( "${FILESDIR}/${P}-fix_build_system.patch" )

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		AR="$(tc-getAR)" \
		PREFIX="${EPREFIX}/usr" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" zstd

	emake -C lib \
		CC="$(tc-getCC)" \
		AR="$(tc-getAR)" \
		PREFIX="${EPREFIX}/usr" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" libzstd
}

src_install() {
	emake \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}/usr" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" install
	einstalldocs

	if ! use static-libs; then
		rm "${ED%/}"/usr/$(get_libdir)/libzstd.a || die
	fi
}
