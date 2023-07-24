# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-1 )
inherit cmake lua-single xdg

DESCRIPTION="Portable Famicom/NES emulator, an evolution of the original FCE Ultra"
HOMEPAGE="https://fceux.com/"
SRC_URI="https://github.com/TASEmulators/fceux/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ffmpeg qt6 x264 x265"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	${LUA_DEPS}
	qt6? ( dev-qt/qtbase:6[gui,opengl,widgets,-gles2-only] )
	!qt6? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtopengl:5[-gles2-only]
		dev-qt/qtwidgets:5
	)
	media-libs/libglvnd
	media-libs/libsdl2[joystick,sound,threads,video]
	sys-libs/zlib:=[minizip]
	ffmpeg? ( media-video/ffmpeg:= )
	x264? ( media-libs/x264:= )
	x265? ( media-libs/x265:= )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-2.4.0-desktop.patch
	"${FILESDIR}"/${PN}-2.4.0-no-git.patch
	"${FILESDIR}"/${PN}-2.4.0-gcc13.patch
)

src_prepare() {
	cmake_src_prepare

	use x264 || sed -i '/pkg_check_modules.*X264/d' src/CMakeLists.txt || die
	use x265 || sed -i '/pkg_check_modules.*X265/d' src/CMakeLists.txt || die
	use ffmpeg || sed -i '/pkg_check_modules.*LIBAV/d' src/CMakeLists.txt || die

	rm output/lua5{1,.1}.dll || die
}

src_configure() {
	local mycmakeargs=(
		-DPUBLIC_RELEASE=yes
		-DQT6=$(usex qt6)
	)

	cmake_src_configure
}

src_install() {
	local DOCS=( README TODO-SDL changelog.txt documentation/. readme.md )
	cmake_src_install

	# remove unused/duplicate files
	rm "${ED}"/usr/share/fceux/{fceux,taseditor}.chm \
		"${ED}"/usr/share/doc/${PF}/fceux{,-net-server}.6 \
		"${ED}"/usr/share/man/man6/fceux-net-server.6 || die
}
