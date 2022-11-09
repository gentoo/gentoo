# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop gnuconfig toolchain-funcs

DESCRIPTION="Viewer for PostScript and PDF documents using Ghostscript"
HOMEPAGE="https://www.gnu.org/software/gv/"
SRC_URI="https://ftp.gnu.org/gnu/gv/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="xinerama"

RDEPEND="
	app-text/ghostscript-gpl
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	>=x11-libs/libXaw3d-1.6-r1[unicode(+)]
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXpm
	x11-libs/libXt
	xinerama? ( x11-libs/libXinerama )"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-resource.patch
	"${FILESDIR}"/${P}-dat.patch
	"${FILESDIR}"/${P}-bounding-box.patch
	"${FILESDIR}"/${P}-bug1071238.patch
	"${FILESDIR}"/${P}-bz1536211.patch
	"${FILESDIR}"/${P}-overflow.patch
	"${FILESDIR}"/${P}-remove-aliasing-violation.patch
)

src_prepare() {
	default
	gnuconfig_update
}

src_configure() {
	export ac_cv_lib_Xinerama_main=$(usex xinerama)
	econf --enable-scrollbar-code
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	rm README.{I18N,TRANSLATION} || die
	default

	doicon "${FILESDIR}"/gv_icon.xpm
	make_desktop_entry gv GhostView gv_icon 'Graphics;Viewer'
}
