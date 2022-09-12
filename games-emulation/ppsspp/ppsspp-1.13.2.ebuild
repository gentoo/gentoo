# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg cmake

DESCRIPTION="A PSP emulator written in C++"
HOMEPAGE="https://www.ppsspp.org/"
SRC_URI="
	https://github.com/hrydgard/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/KhronosGroup/SPIRV-Cross/archive/9acb9ec31f5a8ef80ea6b994bb77be787b08d3d1.tar.gz -> ${P}-ext_SPIRV-Cross.tar.gz
	https://github.com/Kingcom/armips/archive/7885552b208493a6a0f21663770c446c3ba65576.tar.gz -> ${P}-ext_armips.tar.gz
	https://github.com/Tencent/rapidjson/archive/73063f5002612c6bf64fe24f851cd5cc0d83eef9.tar.gz -> ${P}-ext_rapidjson.tar.gz
	https://github.com/hrydgard/glslang/archive/dc11adde23c455a24e13dd54de9b4ede8bdd7db8.tar.gz -> ${P}-ext_glslang.tar.gz
	https://github.com/hrydgard/miniupnp/archive/3a87be33e797ba947b2b2a5f8d087f6c3ff4d93e.tar.gz -> ${P}-ext_miniupnp.tar.gz
	https://github.com/hrydgard/ppsspp-freetype/archive/cbea79dc8fef4d9210e2bac7e7b9b5ff3388197a.tar.gz -> ${P}-ext_native_tools_prebuilt.tar.gz
	discord? ( https://github.com/discordapp/discord-rpc/archive/963aa9f3e5ce81a4682c6ca3d136cddda614db33.tar.gz -> ${P}-ext_discord-rpc.tar.gz )
"

LICENSE="Apache-2.0 BSD BSD-2 GPL-2 JSON MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="discord qt5"
RESTRICT="test"

RDEPEND="
	app-arch/snappy:=
	app-arch/zstd:=
	dev-libs/libzip:=
	dev-util/glslang:=
	media-libs/glew:=
	media-libs/libpng:=
	media-libs/libsdl2[joystick]
	media-video/ffmpeg:0/56.58.58
	sys-libs/zlib:=
	virtual/opengl
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5[-gles2-only]
		dev-qt/qtmultimedia:5[-gles2-only]
		dev-qt/qtopengl:5[-gles2-only]
		dev-qt/qtwidgets:5[-gles2-only]
	)
	!qt5? ( media-libs/libsdl2[X,opengl,sound,video] )
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-CMakeLists-flags.patch
	"${FILESDIR}"/${PN}-disable-ccache-autodetection.patch
)

src_unpack() {
	unpack ${P}.tar.gz

	cd "${S}" || die
	local list=(
		ext_SPIRV-Cross
		ext_armips
		ext_glslang
		ext_miniupnp
		ext_native_tools_prebuilt
		ext_rapidjson
	)
	use discord && list+=( ext_discord-rpc )

	local i
	for i in "${list[@]}" ; do
		tar xf "${DISTDIR}/${P}-${i}.tar.gz" --strip-components 1 -C "${i//_//}" ||
			die "Failed to unpack ${P}-${i}.tar.gz"
	done
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DHEADLESS=false
		-DUSE_DISCORD=$(usex discord)
		-DUSE_SYSTEM_FFMPEG=ON
		-DUSE_SYSTEM_LIBZIP=ON
		-DUSE_SYSTEM_SNAPPY=ON
		-DUSE_SYSTEM_ZSTD=ON
		-DUSING_QT_UI=$(usex qt5)
	)
	cmake_src_configure
}

src_install() {
	insinto /usr/share/${PN}
	doins -r "${BUILD_DIR}/assets"
	exeinto /usr/bin
	doexe "${BUILD_DIR}"/PPSSPP$(usex qt5 Qt SDL)
	make_desktop_entry PPSSPP$(usex qt5 Qt SDL) "PPSSPP ($(usex qt5 Qt SDL))"

	local i
	for i in 16 24 32 48 64 96 128 256 512 ; do
		doicon -s ${i} icons/hicolor/${i}x${i}/apps/${PN}.png
	done
}
