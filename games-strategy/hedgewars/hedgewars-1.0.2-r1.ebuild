# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR=emake
LUA_COMPAT=( lua5-1 )

inherit cmake flag-o-matic lua-single toolchain-funcs xdg-utils

MY_P=${PN}-src-${PV}

DESCRIPTION="A turn-based strategy, artillery, action and comedy game"
HOMEPAGE="https://www.hedgewars.org/"
SRC_URI="https://www.hedgewars.org/download/releases/${MY_P}.tar.bz2"
S="${WORKDIR}"/${MY_P}

LICENSE="GPL-2 Apache-2.0 FDL-1.3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ffmpeg pas2c server"

REQUIRED_USE="${LUA_REQUIRED_USE}"

QA_FLAGS_IGNORED="/usr/bin/hwengine" # pascal sucks
QA_PRESTRIPPED="/usr/bin/hwengine" # pascal sucks

# qtcore:5= - depends on private header
DEPEND="${LUA_DEPS}
	>=dev-games/physfs-3.0.1
	dev-qt/qtcore:5=
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	media-libs/libpng:0=
	media-libs/libsdl2:=[opengl]
	media-libs/sdl2-image:=[png]
	media-libs/sdl2-mixer:=[vorbis]
	media-libs/sdl2-net:=
	media-libs/sdl2-ttf:=
	sys-libs/zlib
	!pas2c? ( ffmpeg? ( media-video/ffmpeg:= ) )
	"
RDEPEND="${DEPEND}
	app-arch/xz-utils
	>=media-fonts/dejavu-2.28
	media-fonts/wqy-zenhei"
BDEPEND="
	dev-qt/linguist-tools:5
	!pas2c? ( dev-lang/fpc )
	pas2c? (
		>=dev-lang/ghc-6.10
		dev-haskell/parsec
		llvm-core/clang
	)
	server? (
		>=dev-lang/ghc-6.10
		dev-haskell/entropy
		dev-haskell/hslogger
		>=dev-haskell/mtl-2
		>=dev-haskell/network-2.3
		dev-haskell/random
		dev-haskell/regex-tdfa
		dev-haskell/sandi
		dev-haskell/sha
		dev-haskell/vector
		dev-haskell/utf8-string
		dev-haskell/yaml
		>=dev-haskell/zlib-0.5.3
	)"

PATCHES=(
	"${FILESDIR}/${PN}-1.0.0-cmake_lua_version.patch"
	"${FILESDIR}/${PN}-1.0.2-respect-cc.patch"
	"${FILESDIR}/${PN}-1.0.2-metainfo.patch"
	"${FILESDIR}/${P}-glext-prototypes.patch"
	"${FILESDIR}/${P}-clang-15.patch"
	"${FILESDIR}/${P}-ffmpeg-6.patch"
	"${FILESDIR}/${P}-cmake4.patch" # bug 956467
)

src_configure() {
	if use pas2c && ! tc-is-clang; then
		# Follow upstream and build with clang
		export CC=${CHOST}-clang
		export CXX=${CHOST}-clang++
		# Filter out flags not implemented by clang
		strip-unsupported-flags
	fi

	local mycmakeargs=(
		-DMINIMAL_FLAGS=ON
		-DDATA_INSTALL_DIR="${EPREFIX}/usr/share/${PN}"
		-Dtarget_binary_install_dir="${EPREFIX}/usr/bin"
		-Dtarget_library_install_dir="${EPREFIX}/usr/$(get_libdir)"
		-DNOSERVER=$(usex !server)
		-DBUILD_ENGINE_C=$(usex pas2c)
		-DNOVIDEOREC=$(usex ffmpeg $(usex pas2c) ON)
		-DCMAKE_VERBOSE_MAKEFILE=TRUE
		# Need to tell the build system where the fonts are located
		# as it uses PhysFS' symbolic link protection mode which
		# prevents us from symlinking the fonts into the right directory
		#   https://hg.hedgewars.org/hedgewars/rev/76ad55807c24
		#   https://icculus.org/physfs/docs/html/physfs_8h.html#aad451d9b3f46f627a1be8caee2eef9b7
		-DFONTS_DIRS="${EPREFIX}/usr/share/fonts/wqy-zenhei;${EPREFIX}/usr/share/fonts/dejavu"
		# upstream sets RPATH that leads to weird breakage
		# https://bugzilla.redhat.com/show_bug.cgi?id=1200193
		-DCMAKE_SKIP_RPATH=ON
		-DLUA_VERSION=$(lua_get_version)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	doman man/${PN}.6
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
