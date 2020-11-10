# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs xdg

DESCRIPTION="graphical PDF viewer which aims to superficially resemble less(1)"
HOMEPAGE="https://github.com/moosotc/llpp"
SRC_URI="https://github.com/moosotc/llpp/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="+ocamlopt"

BDEPEND="
	>=dev-lang/ocaml-4.02:=[ocamlopt?]
	virtual/pkgconfig
"
RDEPEND="
	>=app-text/mupdf-1.12.0:0=
	media-libs/openjpeg:2
	media-libs/fontconfig:1.0
	media-libs/freetype:2
	media-libs/jbig2dec:=
	sys-libs/zlib
	virtual/jpeg:0
	x11-libs/libX11
	x11-misc/xsel
"
DEPEND="${RDEPEND}
	app-arch/bzip2
	app-text/asciidoc
	dev-ml/lablgl:=[glut,ocamlopt?]
	media-libs/libXcm
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-libs/libXmu
"

RESTRICT="!ocamlopt? ( strip )"

PATCHES=( "${FILESDIR}"/${P}-keysym.patch )

src_prepare() {
	default

	# use custom makefile from archlinux with minor changes
	cp "${FILESDIR}"/Makefile "${S}" || die

	# re-add desktop file removed upstream
	cp "${FILESDIR}"/llpp.desktop "${S}"/misc || die
}

src_compile() {
	emake -j1 VERSION=${PV} CC="$(tc-getCC)" LIBDIR="/usr/$(get_libdir)"
}

src_install() {
	emake DESTDIR="${ED}" PREFIX="/usr" install
	dodoc README Thanks
}
