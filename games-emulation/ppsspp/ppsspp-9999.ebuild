# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils desktop git-r3

DESCRIPTION="A PSP emulator written in C++"
HOMEPAGE="https://www.ppsspp.org/"
EGIT_REPO_URI="https://github.com/hrydgard/${PN}.git"
EGIT_SUBMODULES=( '*' )

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
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

src_unpack() {
	use system-ffmpeg && EGIT_SUBMODULES+=( '-ffmpeg' )
	git-r3_src_unpack
}

src_prepare() {
	# https://github.com/hrydgard/ppsspp/blob/150619c5a341f372266bec86fd874ac5a1343a43/UI/NativeApp.cpp#L318
	# patch ppsspp to use /usr/share instead of working dir to find the assets
	sed -i 's|VFSRegister("", new AssetsAssetReader());|VFSRegister("", new DirectoryAssetReader("/usr/share/ppsspp/assets/"));|g' UI/NativeApp.cpp || die "Patching qt assets path failed"

	sed -i -e "s#-O3#-O2#g;" "${S}"/CMakeLists.txt || die
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
