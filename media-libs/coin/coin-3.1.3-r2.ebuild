# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-utils flag-o-matic

MY_P=${P/c/C}

DESCRIPTION="A high-level 3D graphics toolkit, fully compatible with SGI Open Inventor 2.1"
HOMEPAGE="http://www.coin3d.org/"
SRC_URI="ftp://ftp.coin3d.org/pub/coin/src/all/${MY_P}.tar.gz"

LICENSE="|| ( GPL-2 PEL )"
KEYWORDS="amd64 ~arm ppc x86 ~amd64-linux ~x86-linux"
SLOT="0"
IUSE="bzip2 debug doc javascript openal simage static-libs threads zlib"

# NOTE: expat is not really needed as --enable-system-expat is broken
RDEPEND="
	dev-libs/expat
	media-libs/fontconfig
	media-libs/freetype:2
	virtual/opengl
	virtual/glu
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	bzip2? ( app-arch/bzip2 )
	javascript? ( dev-lang/spidermonkey:0 )
	openal? ( media-libs/openal )
	simage? ( media-libs/simage )
	zlib? ( sys-libs/zlib )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-proto/xextproto
	doc? ( app-doc/doxygen )
"
S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-3.1.0-javascript.patch
	"${FILESDIR}"/${P}-pkgconfig-partial.patch
	"${FILESDIR}"/${P}-gcc-4.7.patch
	"${FILESDIR}"/${P}-freetype251.patch
)

DOCS=(
	AUTHORS FAQ FAQ.legal NEWS README RELNOTES THANKS
	docs/{ChangeLog.v${PV},HACKING,oiki-launch.txt}
)

src_configure() {
	append-cppflags -I"${EPREFIX}/usr/include/freetype2"
	# Prefer link-time linking over dlopen
	local myeconfargs=(
		htmldir="${EPREFIX}/usr/share/doc/${PF}/html"
		--disable-dl-fontconfig
		--disable-dl-freetype
		--disable-dl-libbzip2
		--disable-dl-openal
		--disable-dl-simage
		--disable-dl-zlib
		--disable-dyld
		--disable-loadlibrary
		--disable-man
		--disable-java-wrapper
		--enable-3ds-import
		--enable-compact
		--enable-dl-glu
		--enable-dl-spidermonkey
		--enable-system-expat
		--includedir="${EPREFIX}/usr/include/${PN}"
		--with-fontconfig
		--with-freetype
		$(use_with bzip2)
		$(use_enable debug)
		$(use_enable debug symbols)
		$(use_enable doc html)
		$(use_enable javascript javascript-api)
		$(use_with javascript spidermonkey)
		$(use_enable openal sound)
		$(use_with openal)
		$(use_with simage)
		$(use_enable threads threadsafe)
		$(use_with zlib)
		)
	autotools-utils_src_configure
}

src_install() {
	# Remove Coin from Libs.private
	sed -e '/Libs.private/s/ -lCoin//' -i "${BUILD_DIR}"/Coin.pc || die

	autotools-utils_src_install
}
