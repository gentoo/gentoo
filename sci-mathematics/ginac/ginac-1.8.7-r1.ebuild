# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

inherit python-any-r1

DESCRIPTION="C++ library and tools for symbolic calculations"
SRC_URI="http://www.ginac.de/${P}.tar.bz2"
HOMEPAGE="https://www.ginac.de/"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples"

RDEPEND=">=sci-libs/cln-1.2.2"
DEPEND="${RDEPEND}"
BDEPEND="
	${PYTHON_DEPS}
	virtual/pkgconfig
	doc? (
		app-doc/doxygen
		dev-texlive/texlive-fontsrecommended
		>=media-gfx/fig2dev-3.2.9-r1
		dev-texlive/texlive-latexextra
		virtual/texi2dvi
	)"

PATCHES=( "${FILESDIR}"/${PN}-1.8.2-pkgconfig.patch )

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
