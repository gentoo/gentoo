# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop toolchain-funcs xdg

DESCRIPTION="Image editor with tiff, jpeg and png support"
HOMEPAGE="http://sf-xpaint.sourceforge.net/"
SRC_URI="mirror://sourceforge/sf-xpaint/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="pgf tiff"
# jpeg2k disabled for blocking media-libs/openjpeg:0 security cleanup, bug 735592

RDEPEND="
	media-libs/fontconfig
	media-libs/libjpeg-turbo:=
	media-libs/libpng:0=
	media-libs/netpbm
	x11-libs/libX11
	>=x11-libs/libXaw3dXft-1.6.2h[unicode(+)]
	x11-libs/libXext
	x11-libs/libXft
	x11-libs/libXmu
	x11-libs/libXpm
	x11-libs/libXt
	pgf? ( media-libs/libpgf )
	tiff? ( media-libs/tiff:0 )
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-3.1.3-libtool-clang.patch
	"${FILESDIR}"/${PN}-3.1.3-gentoo-qa.patch
	"${FILESDIR}"/${PN}-3.1.3-gentoo-prefix.patch
	"${FILESDIR}"/${P}-gentoo-shared-lib.patch
	"${FILESDIR}"/${P}-gentoo-lto.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
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
}

src_install() {
	default
	emake \
		WITH_PGF="$(usex pgf "yes" "no")" \
		DESTDIR="${ED}" \
		-C util install
	doicon icons/xpaint.svg
	make_desktop_entry "${PN}"
	find "${ED}" -name '*.la' -delete || die
}
