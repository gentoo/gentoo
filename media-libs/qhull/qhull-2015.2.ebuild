# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils flag-o-matic

DESCRIPTION="Geometry library"
HOMEPAGE="http://www.qhull.org"
SRC_URI="${HOMEPAGE}/download/${PN}-2015-src-7.2.0.tgz -> ${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc static-libs"

DOCS=( Announce.txt File_id.diz README.txt REGISTER.txt )

PATCHES=(
	"${FILESDIR}"/${PN}-2012.1-64bit.patch
	)

src_configure() {
	append-flags -fno-strict-aliasing
	mycmakeargs+=(
		-DLIB_INSTALL_DIR="${EPREFIX}"/usr/$(get_libdir)
		-DDOC_INSTALL_DIR="${EPREFIX}"/usr/share/doc/${P}/html
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	# compatibility with previous installs
	dosym libqhull /usr/include/qhull
	if ! use doc; then
		rm -rf "${ED}"/usr/share/doc/${P}/html || die
	fi
	if ! use static-libs; then
		rm -f "${ED}"/usr/$(get_libdir)/lib*.a || die
	fi
}
