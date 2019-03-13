# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools-utils

DESCRIPTION="C++ library and tools for symbolic calculations"
SRC_URI="http://www.ginac.de/${P}.tar.bz2"
HOMEPAGE="https://www.ginac.de/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"
IUSE="doc static-libs"

RDEPEND=">=sci-libs/cln-1.2.2"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen
		   media-gfx/transfig
		   virtual/texi2dvi
		   dev-texlive/texlive-fontsrecommended
		 )"

PATCHES=( "${FILESDIR}"/${PN}-1.5.1-pkgconfig.patch )

src_configure() {
	local myeconfargs=( --disable-rpath )
	autotools-utils_src_configure
}

src_compile() {
	autotools-utils_src_compile
	if use doc; then
		export VARTEXFONTS="${T}"/fonts
		cd "${BUILD_DIR}/doc/reference"
		emake html pdf
		cd "${BUILD_DIR}/doc/tutorial"
		emake ginac.pdf ginac.html
	fi
}

src_install() {
	autotools-utils_src_install
	if use doc; then
		cd "${BUILD_DIR}"/doc
		insinto /usr/share/doc/${PF}
		newins tutorial/ginac.pdf tutorial.pdf
		newins reference/reference.pdf reference.pdf
		insinto /usr/share/doc/${PF}/html/reference
		doins -r reference/html_files/*
		insinto /usr/share/doc/${PF}/html
		newins tutorial/ginac.html tutorial.html
		insinto /usr/share/doc/${PF}/examples
		doins "${S}"/doc/examples/*.cpp examples/ginac-examples.*
	fi
}
