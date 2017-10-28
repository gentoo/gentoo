# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils eutils gnome2-utils

DESCRIPTION="A kart racing game starring Tux, the linux penguin (TuxKart fork)"
HOMEPAGE="https://supertuxkart.net/"
SRC_URI="mirror://sourceforge/${PN}/SuperTuxKart/${PV}/${P}-src.tar.xz
	mirror://gentoo/${PN}.png"

LICENSE="GPL-2 GPL-3 CC-BY-SA-3.0 CC-BY-2.0 public-domain ZLIB"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug fribidi wiimote"

# don't unbundle irrlicht and bullet
# both are modified and system versions will break the game
# https://sourceforge.net/p/irrlicht/feature-requests/138/

RDEPEND="
	media-libs/glew:0=
	media-libs/libpng:0=
	media-libs/libvorbis
	media-libs/openal
	net-libs/enet:1.3=
	net-misc/curl
	sys-libs/zlib
	virtual/glu
	virtual/jpeg:0
	virtual/libintl
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXxf86vm
	fribidi? ( dev-libs/fribidi )
	wiimote? ( net-wireless/bluez )"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-0.9.2-unbundle-enet.patch
	"${FILESDIR}"/${PN}-0.9.2-unbundle-libs.patch
	"${FILESDIR}"/${PN}-0.9.2-fix-angelscript.patch
	"${FILESDIR}"/${PN}-0.9.2-irrlicht-arch-support.patch
	"${FILESDIR}"/${PN}-0.9.2-irrlicht-as-needed.patch
	"${FILESDIR}"/${PN}-0.9.2-irrlicht-bundled-libs.patch
	"${FILESDIR}"/${PN}-0.9.2-irrlicht-system-libs.patch
	"${FILESDIR}"/${PN}-0.9.2-fix-buildsystem.patch
)

src_prepare() {
	cmake-utils_src_prepare

	# remove bundled libraries, just to be sure
	rm -r lib/{enet,glew,jpeglib,libpng,zlib} || die
}

src_configure() {
	local mycmakeargs=(
		# system dev-libs/angelscript leads
		# to failed assert segfaults
		-DUSE_SYSTEM_ANGELSCRIPT=OFF
		-DUSE_FRIBIDI=$(usex fribidi)
		-DUSE_WIIUSE=$(usex wiimote)
		-DSTK_INSTALL_BINARY_DIR=bin
		-DSTK_INSTALL_DATA_DIR=share/${PN}
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	dodoc CHANGELOG.md TODO.md

	doicon -s 64 "${DISTDIR}"/${PN}.png
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
