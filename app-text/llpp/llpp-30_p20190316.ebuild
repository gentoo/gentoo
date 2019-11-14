# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs xdg-utils

DESCRIPTION="Graphical PDF viewer which aims to superficially resemble less(1)"
HOMEPAGE="https://github.com/moosotc/llpp"
MY_COMMIT="1f3ae0843d5877a0e599d8411d433bd9b0078157"
SRC_URI="https://github.com/moosotc/llpp/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="+ocamlopt static-libs"

RDEPEND=">=app-text/mupdf-1.15.0:0=[static-libs=]
	media-libs/openjpeg:2[static-libs=]
	media-libs/fontconfig:1.0[static-libs=]
	media-libs/freetype:2[static-libs=]
	media-libs/jbig2dec:=[static-libs=]
	sys-libs/zlib[static-libs=]
	virtual/jpeg:0[static-libs=]
	x11-libs/libX11[static-libs=]
	x11-misc/xsel"
DEPEND="${RDEPEND}
	app-text/asciidoc
	virtual/pkgconfig
	static-libs? (
		app-arch/bzip2[static-libs]
		media-libs/libXcm[static-libs]
		x11-libs/libXau[static-libs]
		x11-libs/libXdmcp[static-libs]
		x11-libs/libXmu[static-libs] )
	>=dev-lang/ocaml-4.05[ocamlopt?]
	dev-ml/lablgl[glut,ocamlopt?]"

RESTRICT="!ocamlopt? ( strip )"

PATCHES=( "${FILESDIR}"/${PN}-30-keysym.patch )

S="${WORKDIR}"/"${PN}"-"${MY_COMMIT}"

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
