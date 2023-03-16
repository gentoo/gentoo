# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs xdg

DESCRIPTION="Graphical PDF viewer which aims to superficially resemble less(1)"
HOMEPAGE="https://github.com/criticic/llpp"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="+ocamlopt"

RDEPEND=">=app-text/mupdf-1.17.0:0=
	app-arch/bzip2
	media-libs/fontconfig:1.0
	media-libs/freetype:2
	media-libs/jbig2dec:=
	media-libs/openjpeg:2
	sys-libs/zlib
	virtual/jpeg:0
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-misc/xsel
"
DEPEND="${RDEPEND}
	dev-ml/lablgl:=[glut,ocamlopt?]"
BDEPEND="
	app-text/asciidoc
	>=dev-lang/ocaml-4.09[ocamlopt?]
	virtual/pkgconfig
"

RESTRICT="!ocamlopt? ( strip )"

src_prepare() {
	default

	# use custom makefile from archlinux with minor changes
	cp "${FILESDIR}"/${P}-makefile "${S}"/Makefile || die

	# re-add desktop file removed upstream
	cp "${FILESDIR}"/llpp.desktop "${S}"/misc || die

	# remove empty interface definition
	rm "${S}"/main.mli || die
}

src_compile() {
	tc-export PKG_CONFIG
	emake -j1 VERSION=${PV} CC="$(tc-getCC)" LIBDIR="/usr/$(get_libdir)"
}

src_install() {
	emake DESTDIR="${ED}" PREFIX="/usr" install
	dodoc README Thanks
}
