# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake desktop xdg

DESCRIPTION="A kart racing game starring Tux, the linux penguin (TuxKart fork)"
HOMEPAGE="https://supertuxkart.net/"
SRC_URI="mirror://sourceforge/${PN}/SuperTuxKart/${PV}/${P}-src.tar.xz
	mirror://gentoo/${PN}.png"

LICENSE="GPL-2 GPL-3 CC-BY-SA-3.0 CC-BY-SA-4.0 CC0-1.0 public-domain ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug nettle recorder wiimote"

# don't unbundle irrlicht and bullet
# both are modified and system versions will break the game
# https://sourceforge.net/p/irrlicht/feature-requests/138/

RDEPEND="
	dev-libs/angelscript:=
	dev-libs/fribidi
	media-libs/freetype:2
	media-libs/glew:0=
	media-libs/harfbuzz:=
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
	nettle? ( dev-libs/nettle:= )
	!nettle? (
		>=dev-libs/openssl-1.0.1d:0=
	)
	recorder? ( media-libs/libopenglrecorder )
	wiimote? ( net-wireless/bluez )"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig"

S="${WORKDIR}/${P}-src"

PATCHES=(
	"${FILESDIR}"/${PN}-1.1-irrlicht-arch-support.patch
	"${FILESDIR}"/${PN}-0.9.3-irrlicht-system-libs.patch
	"${FILESDIR}"/${PN}-1.1-fix-buildsystem.patch
)

src_prepare() {
	cmake_src_prepare

	# remove bundled libraries, just to be sure
	rm -r lib/{angelscript,enet,glew,jpeglib,libpng,zlib} || die
}

src_configure() {
	local mycmakeargs=(
		-DUSE_SYSTEM_ANGELSCRIPT=ON
		-DUSE_SYSTEM_ENET=ON
		-DUSE_SYSTEM_GLEW=ON
		-DUSE_SYSTEM_SQUISH=OFF
		-DUSE_SYSTEM_WIIUSE=OFF
		-DUSE_IPV6=OFF # not supported by system enet
		-DOpenGL_GL_PREFERENCE=GLVND
		-DUSE_CRYPTO_OPENSSL=$(usex nettle no yes)
		-DENABLE_WAYLAND_DEVICE=OFF
		-DBUILD_RECORDER=$(usex recorder)
		-DUSE_WIIUSE=$(usex wiimote)
		-DSTK_INSTALL_BINARY_DIR=bin
		-DSTK_INSTALL_DATA_DIR=share/${PN}
		-DBUILD_SHARED_LIBS=OFF # build bundled libsquish as static library
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	dodoc CHANGELOG.md

	doicon -s 64 "${DISTDIR}"/${PN}.png
}
