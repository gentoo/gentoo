# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

DESCRIPTION="C++ library and tools for symbolic calculations"
SRC_URI="http://www.ginac.de/${P}.tar.bz2"
HOMEPAGE="https://www.ginac.de/"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
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
	append-cxxflags -std=c++14
	econf --disable-rpath
}

src_compile() {
	emake
	if use doc; then
		export VARTEXFONTS="${T}"/fonts
		pushd doc/reference >> /dev/null || die "pushd doc/reference failed"
		emake html pdf
		popd >> /dev/null
		pushd doc/tutorial >> /dev/null || die "pushd doc/tutorial failed"
		emake ginac.pdf ginac.html
		popd >> /dev/null
	fi
}

src_test() {
	pushd ../${P}_build > /dev/null
	emake check
	popd > /dev/null
}

src_install() {
	default
	if use doc; then
		pushd doc > /dev/null || die "pushd doc failed"
		newdoc tutorial/ginac.pdf tutorial.pdf
		newdoc reference/reference.pdf reference.pdf
		docinto html/reference
		dodoc -r reference/html_files/.
		docinto html
		newdoc tutorial/ginac.html tutorial.html
		docinto examples
		dodoc "${S}"/doc/examples/*.cpp examples/ginac-examples.*
		popd > /dev/null
	fi
}
