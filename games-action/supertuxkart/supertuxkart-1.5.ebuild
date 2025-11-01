# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop flag-o-matic xdg

MY_P="SuperTuxKart-${PV}-src"
DESCRIPTION="A kart racing game starring Tux, the linux penguin (TuxKart fork)"
HOMEPAGE="https://supertuxkart.net/"
SRC_URI="
	https://github.com/${PN}/stk-code/releases/download/${PV}/${MY_P}.tar.gz
	mirror://gentoo/${PN}.png
"
S="${WORKDIR}/${MY_P}"
LICENSE="GPL-2 GPL-3 CC-BY-SA-3.0 CC-BY-SA-4.0 CC0-1.0 public-domain ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="debug nettle recorder sqlite vulkan wiimote"

# - Don't unbundle irrlicht and bullet
# both are modified and system versions will break the game
# https://sourceforge.net/p/irrlicht/feature-requests/138/
RDEPEND="
	dev-cpp/libmcpp
	dev-libs/angelscript:=
	media-libs/freetype:2
	media-libs/harfbuzz:=[truetype]
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	media-libs/libsdl2[opengl,video]
	media-libs/libvorbis
	media-libs/openal
	net-libs/enet:1.3=
	net-misc/curl
	sys-libs/zlib
	virtual/libintl
	nettle? ( dev-libs/nettle:= )
	!nettle? ( >=dev-libs/openssl-1.0.1d:= )
	recorder? ( media-libs/libopenglrecorder )
	sqlite? ( dev-db/sqlite:3 )
	vulkan? ( media-libs/shaderc )
	wiimote? ( net-wireless/bluez:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.1-irrlicht-arch-support.patch
	"${FILESDIR}"/${PN}-1.3-irrlicht-system-libs.patch
)

src_prepare() {
	# Delete unused code with CMake issues.
	rm -r lib/wiiuse/cmake/{cmake-2.8.0-modules/,DashboardScript.cmake.in,FindOpenHaptics.cmake} switch/ || die

	cmake_src_prepare
}

src_configure() {
	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/858521
	# https://github.com/supertuxkart/stk-code/issues/5035
	#
	# The issue is bundled code from sci-physics/bullet which is unlikely to
	# be debundled.
	#
	# Do not trust with LTO either.
	append-flags -fno-strict-aliasing
	filter-lto

	local mycmakeargs=(
		-DUSE_SQLITE3=$(usex sqlite)
		-DUSE_SYSTEM_ANGELSCRIPT=ON
		-DUSE_SYSTEM_ENET=ON
		-DUSE_SYSTEM_MCPP=ON
		-DUSE_SYSTEM_SQUISH=OFF
		-DUSE_SYSTEM_WIIUSE=OFF
		-DUSE_IPV6=OFF # not supported by system enet
		-DUSE_CRYPTO_OPENSSL=$(usex nettle no yes)
		-DBUILD_RECORDER=$(usex recorder)
		-DNO_SHADERC=$(usex !vulkan)
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

	if use wiimote; then
		# This gets erroneously installed.
		rm "${ED}"/usr/$(get_libdir)/libwiiuse.a || die
	fi
}
