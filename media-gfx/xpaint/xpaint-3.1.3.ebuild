# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop toolchain-funcs xdg-utils

DESCRIPTION="Image editor with tiff, jpeg and png support"
HOMEPAGE="http://sf-xpaint.sourceforge.net/"
SRC_URI="mirror://sourceforge/sf-xpaint/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="pgf tiff"
# jpeg2k disabled for blocking media-libs/openjpeg:0 security cleanup, bug 735592

RDEPEND="
	media-libs/fontconfig
	media-libs/freetype:2
	media-libs/libjpeg-turbo:=
	media-libs/libpng:0=
	media-libs/netpbm:=
	x11-libs/libICE
	x11-libs/libX11
	>=x11-libs/libXaw3dXft-1.6.2h[unicode]
	x11-libs/libXext
	x11-libs/libXft
	x11-libs/libXmu
	x11-libs/libXpm
	x11-libs/libXt
	sys-libs/zlib
	pgf? ( media-libs/libpgf )
	tiff? (
		media-libs/jbigkit:0=
		media-libs/tiff:0
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/bison
	sys-devel/flex
	sys-devel/libtool
	virtual/pkgconfig
	x11-misc/imake
"

PATCHES=(
	"${FILESDIR}"/${P}-libtool-clang.patch
	"${FILESDIR}"/${P}-gentoo-qa.patch
	"${FILESDIR}"/${P}-gentoo-prefix.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# regenerate resources in app-defaults
	# Local.xawdefs is missing and imake was complaining about it, so use it to redefine SHAREDIR
	echo "SHAREDIR = \"${EPREFIX}\"/usr/share/xpaint" > Local.xawdefs || die
	xmkmf || die
	mv Makefile Makefile.resources || die

	econf \
		$(use_enable tiff) \
		--disable-libdvipgm \
		--disable-libopenjpeg
}

src_compile() {
	# clean up
	emake clean
	emake -C util clean

	# parallel make still fails sometimes
	emake substads
	emake xpaint.1

	default
	emake \
		WITH_PGF="$(usex pgf "yes" "no")" \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		includedir="${EPREFIX}"/usr/include \
		-C util

	# regenerate resources in app-defaults
	(rm XPaint.ad && emake -f Makefile.resources XPaint.ad) || die
}

src_install() {
	default
	emake \
		WITH_PGF="$(usex pgf "yes" "no")" \
		DESTDIR="${ED}" \
		-C util install
	doicon icons/xpaint.svg
	make_desktop_entry "${PN}"
	find "${ED}" \( -name '*.la' -o -name '*.a' \) -type f -delete || die
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
