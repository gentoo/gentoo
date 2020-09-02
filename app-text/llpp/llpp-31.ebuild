# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs xdg

DESCRIPTION="Graphical PDF viewer which aims to superficially resemble less(1)"
HOMEPAGE="https://github.com/moosotc/llpp"
SRC_URI="https://github.com/moosotc/llpp/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="+ocamlopt static-libs"

BDEPEND="
	app-text/asciidoc
	virtual/pkgconfig"
RDEPEND="
	=app-text/mupdf-1.16*:0=[static-libs?]
	app-arch/bzip2[static-libs?]
	media-libs/fontconfig:1.0[static-libs?]
	media-libs/freetype:2[static-libs?]
	media-libs/jbig2dec:=[static-libs?]
	media-libs/openjpeg:2=[static-libs?]
	sys-libs/zlib:=[static-libs?]
	virtual/jpeg:0[static-libs?]
	x11-libs/libX11[static-libs?]
	x11-libs/libXau[static-libs?]
	x11-libs/libXdmcp[static-libs?]
	x11-misc/xsel"
DEPEND="${RDEPEND}
	>=dev-lang/ocaml-4.09[ocamlopt?]
	dev-ml/lablgl[glut,ocamlopt?]"

RESTRICT="!ocamlopt? ( strip )"

PATCHES=( "${FILESDIR}"/${PN}-30-keysym.patch )

src_prepare() {
	default

	# use custom makefile from archlinux with minor changes
	cp "${FILESDIR}"/Makefile "${S}" || die

	# re-add desktop file removed upstream
	cp "${FILESDIR}"/llpp.desktop "${S}"/misc || die

	# remove empty interface definition
	rm "${S}"/main.mli || die
}

src_compile() {
	emake -j1 VERSION=${PV} CC="$(tc-getCC)" LIBDIR="/usr/$(get_libdir)"
}

src_install() {
	emake DESTDIR="${ED}" PREFIX="/usr" install
	dodoc README Thanks
}
