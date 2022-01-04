# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit python-any-r1

DESCRIPTION="C++ library and tools for symbolic calculations"
SRC_URI="http://www.ginac.de/${P}.tar.bz2"
HOMEPAGE="https://www.ginac.de/"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux"
IUSE="doc examples"

RDEPEND=">=sci-libs/cln-1.2.2"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	virtual/pkgconfig
	doc? (
		app-doc/doxygen
		dev-texlive/texlive-fontsrecommended
		media-gfx/transfig
		virtual/texi2dvi
	)"

PATCHES=( "${FILESDIR}"/${PN}-1.5.1-pkgconfig.patch )

src_configure() {
	econf \
		--disable-rpath \
		--disable-static
}

src_compile() {
	emake

	if use doc; then
		local -x VARTEXFONTS="${T}"/fonts
		emake -C doc/reference html pdf
		emake -C doc/tutorial ginac.pdf ginac.html
	fi
}

src_install() {
	default

	if use doc; then
		pushd doc >/dev/null || die
		newdoc tutorial/ginac.pdf tutorial.pdf
		newdoc reference/reference.pdf reference.pdf

		docinto html/reference
		dodoc -r reference/html_files/.

		docinto html
		newdoc tutorial/ginac.html tutorial.html
		popd >/dev/null || die
	fi

	if use examples; then
		pushd doc >/dev/null || die
		docinto examples
		dodoc examples/*.cpp examples/ginac-examples.*
		docompress -x /usr/share/doc/${PF}/examples
		popd >/dev/null || die
	fi

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}
