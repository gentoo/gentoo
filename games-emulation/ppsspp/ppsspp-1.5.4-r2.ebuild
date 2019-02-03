# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils desktop

DESCRIPTION="A PSP emulator written in C++"
HOMEPAGE="https://www.ppsspp.org/"
SRC_URI="
	https://github.com/hrydgard/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	!system-ffmpeg? ( https://github.com/hrydgard/ppsspp-ffmpeg/archive/a2e98d7ba4c7c5cac08608732c3058cb46e3e0ef.tar.gz -> ${P}-ffmpeg.tar.gz )
	https://github.com/hrydgard/ppsspp-lang/archive/1e3e4a0ba0ca8c0a092e027dfb7c1c4778366db5.tar.gz -> ${P}-assets_lang.tar.gz
	https://github.com/hrydgard/pspautotests/archive/d02ba7407050f445edf9e908374ad4bf3b2f237b.tar.gz -> ${P}-pspautotests.tar.gz
	https://github.com/hrydgard/minidx9/archive/7751cf73f5c06f1be21f5f31c3e2d9a7bacd3a93.tar.gz -> ${P}-dx9sdk.tar.gz
	https://github.com/hrydgard/glslang/archive/2edde6665d9a56ead5ea0e55b4e64d9a803e6164.tar.gz -> ${P}-ext_glslang.tar.gz
	https://github.com/Kingcom/armips/archive/8b4cadaf62d7de42d374056fc6aafc555f2bc7dc.tar.gz -> ${P}-ext_armips.tar.gz
	https://github.com/Kingcom/tinyformat/archive/b7f5a22753c81d834ab5133d655f1fd525280765.tar.gz -> ${P}-ext_armips_ext_tinyformat.tar.gz
	https://github.com/KhronosGroup/SPIRV-Cross/archive/90966d50f57608587bafd95b4e345b02b814754a.tar.gz -> ${P}-ext_SPIRV-Cross.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="headless libav +qt5 sdl +system-ffmpeg"
REQUIRED_USE="!qt5? ( sdl )"

RDEPEND="
	app-arch/snappy:=
	dev-libs/libzip:=
	media-libs/glew:=
	sys-libs/zlib:=
	virtual/opengl
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtopengl:5
		dev-qt/qtwidgets:5
		!sdl? ( dev-qt/qtmultimedia:5 )
	)
	sdl? ( media-libs/libsdl2 )
	system-ffmpeg? (
		!libav? ( media-video/ffmpeg:= )
		libav? ( media-video/libav:= )
	)
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.2-assets-lookup.patch
	"${FILESDIR}"/${PN}-1.4-O2.patch
	"${FILESDIR}"/${P}-ffmpeg-4.patch
)

src_unpack() {
	unpack "${P}.tar.gz"
	cd "${S}" || die
	local i list=( assets_lang pspautotests dx9sdk ext_glslang ext_armips ext_SPIRV-Cross ext_armips_ext_tinyformat )
	if ! use system-ffmpeg; then
		list+=( ffmpeg )
	fi
	for i in "${list[@]}"; do
		tar xf "${DISTDIR}/${P}-${i}.tar.gz" --strip-components 1 -C "${i//_//}" || die "Failed to unpack ${P}-${i}.tar.gz"
	done
}

src_prepare() {
	if ! use system-ffmpeg; then
		sed -i -e "s#-O3#-O2#g;" "${S}"/ffmpeg/linux_*.sh || die
	fi
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DHEADLESS=$(usex headless)
		-DUSING_QT_UI=$(usex qt5)
		$(cmake-utils_use_find_package sdl SDL2)
		-DUSE_SYSTEM_FFMPEG=$(usex system-ffmpeg)
	)
	cmake-utils_src_configure
}

src_install() {
	use headless && dobin "${BUILD_DIR}/PPSSPPHeadless"
	insinto /usr/share/"${PN}"
	doins -r "${BUILD_DIR}/assets"
	dobin "${BUILD_DIR}/PPSSPP$(usex qt5 Qt SDL)"
	local i
	for i in 16 24 32 48 64 96 128 256 512 ; do
		doicon -s ${i} "icons/hicolor/${i}x${i}/apps/${PN}.png"
	done
	make_desktop_entry "PPSSPP$(usex qt5 Qt SDL)" "PPSSPP ($(usex qt5 Qt SDL))" "${PN}" "Game"
}

pkg_postinst() {
	if use system-ffmpeg; then
		ewarn "system-ffmpeg USE flag is enabled, some bugs might arise due to it."
		ewarn "See https://github.com/hrydgard/ppsspp/issues/9026 for more informations."
	fi
}
