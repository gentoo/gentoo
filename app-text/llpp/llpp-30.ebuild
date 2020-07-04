# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs xdg-utils

DESCRIPTION="graphical PDF viewer which aims to superficially resemble less(1)"
HOMEPAGE="https://github.com/moosotc/llpp"
SRC_URI="https://github.com/moosotc/llpp/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="+ocamlopt static"

LIB_DEPEND=">=app-text/mupdf-1.12.0:0=[static-libs]
	media-libs/openjpeg:2[static-libs]
	media-libs/fontconfig:1.0[static-libs]
	media-libs/freetype:2[static-libs]
	media-libs/jbig2dec:=[static-libs]
	sys-libs/zlib[static-libs]
	virtual/jpeg:0[static-libs]
	x11-libs/libX11[static-libs]"
RDEPEND="x11-misc/xsel
	!static? ( ${LIB_DEPEND//\[static-libs]} )"
DEPEND="${RDEPEND}
	app-text/asciidoc
	virtual/pkgconfig
	static? ( ${LIB_DEPEND}
		app-arch/bzip2[static-libs]
		media-libs/libXcm[static-libs]
		x11-libs/libXau[static-libs]
		x11-libs/libXdmcp[static-libs]
		x11-libs/libXmu[static-libs] )
	>=dev-lang/ocaml-4.02[ocamlopt?]
	dev-ml/lablgl[glut,ocamlopt?]"

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
	emake DESTDIR="${D}" PREFIX="/usr" install
	dodoc README Thanks
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
