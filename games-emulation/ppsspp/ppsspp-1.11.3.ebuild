# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake desktop xdg

DESCRIPTION="A PSP emulator written in C++"
HOMEPAGE="https://www.ppsspp.org/"
SRC_URI="
	https://github.com/hrydgard/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/KhronosGroup/SPIRV-Cross/archive/a1f7c8dc8ea2f94443951ee27003bffa562c1f13.tar.gz -> ${P}-ext_SPIRV-Cross.tar.gz
	https://github.com/Kingcom/armips/archive/7885552b208493a6a0f21663770c446c3ba65576.tar.gz -> ${P}-ext_armips.tar.gz
	https://github.com/Tencent/rapidjson/archive/73063f5002612c6bf64fe24f851cd5cc0d83eef9.tar.gz -> ${P}-ext_rapidjson.tar.gz
	https://github.com/hrydgard/glslang/archive/d0850f875ec392a130ccf00018dab458b546f27c.tar.gz -> ${P}-ext_glslang.tar.gz
	https://github.com/hrydgard/miniupnp/archive/7e229ddd635933239583ab190d9b614bde018157.tar.gz -> ${P}-ext_miniupnp.tar.gz
	https://github.com/hrydgard/ppsspp-freetype/archive/cbea79dc8fef4d9210e2bac7e7b9b5ff3388197a.tar.gz -> ${P}-ext_native_tools_prebuilt.tar.gz
	https://github.com/hrydgard/ppsspp-lang/archive/6bd5b4bc983917ea8402f73c726b46e36f3de0b4.tar.gz -> ${P}-assets_lang.tar.gz
	!system-ffmpeg? ( https://github.com/hrydgard/ppsspp-ffmpeg/archive/0b28335acea4f429ae798c5e75232e54881bf164.tar.gz -> ${P}-ffmpeg.tar.gz )
	discord? ( https://github.com/discordapp/discord-rpc/archive/3d3ae7129d17643bc706da0a2eea85aafd10ab3a.tar.gz -> ${P}-ext_discord-rpc.tar.gz )
"

RESTRICT="test"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="discord qt5 sdl +system-ffmpeg"
REQUIRED_USE="!qt5? ( sdl )"

RDEPEND="
	app-arch/snappy:=
	dev-libs/libzip:=
	dev-util/glslang:=
	media-libs/glew:=
	sys-libs/zlib:=
	virtual/opengl
	sdl? ( media-libs/libsdl2 )
	system-ffmpeg? ( media-video/ffmpeg:= )
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5[-gles2-only]
		dev-qt/qtmultimedia:5[-gles2-only]
		dev-qt/qtopengl:5[-gles2-only]
		dev-qt/qtwidgets:5[-gles2-only]
	)
"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack "${P}.tar.gz"

	cd "${S}" || die
	local i list=(
		assets_lang
		ext_SPIRV-Cross
		ext_armips
		ext_glslang
		ext_miniupnp
		ext_native_tools_prebuilt
		ext_rapidjson
	)
	! use system-ffmpeg && list+=( ffmpeg )
	use discord && list+=( ext_discord-rpc )
	for i in "${list[@]}"; do
		tar xf "${DISTDIR}/${P}-${i}.tar.gz" --strip-components 1 -C "${i//_//}" || die "Failed to unpack ${P}-${i}.tar.gz"
	done
}

src_prepare() {
	if ! use system-ffmpeg; then
		sed -i -e "s#-O3#-O2#g;" "${S}"/ffmpeg/linux_*.sh || die
	fi

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package sdl SDL2)
		-DHEADLESS=false
		-DUSE_DISCORD=$(usex discord)
		-DUSE_SYSTEM_FFMPEG=$(usex system-ffmpeg)
		-DUSE_SYSTEM_LIBZIP=ON
		-DUSE_SYSTEM_SNAPPY=ON
		-DUSING_QT_UI=$(usex qt5)
	)
	cmake_src_configure
}

src_install() {
	insinto /usr/share/"${PN}"
	doins -r "${BUILD_DIR}/assets"

	local i
	for i in 16 24 32 48 64 96 128 256 512 ; do
		doicon -s "${i}" icons/hicolor/"${i}x${i}"/apps/"${PN}.png"
	done

	dobin "${BUILD_DIR}/PPSSPP$(usex qt5 Qt SDL)"
	make_desktop_entry "PPSSPP$(usex qt5 Qt SDL)" "PPSSPP ($(usex qt5 Qt SDL))" "${PN}" "Game"
}

pkg_postinst() {
	xdg_pkg_postinst

	if use system-ffmpeg; then
		ewarn "system-ffmpeg USE flag is enabled, some bugs might arise due to it."
		ewarn "See https://github.com/hrydgard/ppsspp/issues/9026 for more informations."
	fi
}
