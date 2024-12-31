# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-1 luajit )
inherit cmake lua-single xdg

DESCRIPTION="Portable Famicom/NES emulator, an evolution of the original FCE Ultra"
HOMEPAGE="https://fceux.com/"
SRC_URI="
	https://github.com/TASEmulators/fceux/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="archive ffmpeg x264 x265"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="${LUA_DEPS}
	dev-qt/qtbase:6[gui,opengl,widgets,-gles2-only]
	media-libs/libglvnd
	media-libs/libsdl2[joystick,sound,threads(+),video]
	sys-libs/zlib:=[minizip]
	archive? ( app-arch/libarchive:= )
	ffmpeg? ( media-video/ffmpeg:= )
	x264? ( media-libs/x264:= )
	x265? ( media-libs/x265:= )
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-2.4.0-desktop.patch
	"${FILESDIR}"/${PN}-2.4.0-no-git.patch
	"${FILESDIR}"/${PN}-2.6.6-luajit.patch
	"${FILESDIR}"/${PN}-2.6.6-no-glx.patch
)

src_prepare() {
	cmake_src_prepare

	local use
	for use in archive:libarchive ffmpeg:libav x264 x265; do
		use ${use%:*} ||
			sed -i "/check_modules( ${use#*:} /Id" src/CMakeLists.txt || die
	done

	rm output/*.{chm,dll} || die # windows-only
}

src_configure() {
	local mycmakeargs=(
		-DGLVND=yes
		-DPUBLIC_RELEASE=yes
		-DQT6=ON
	)

	cmake_src_configure
}

src_install() {
	local DOCS=( README TODO-SDL changelog.txt documentation/. readme.md )
	cmake_src_install

	rm "${ED}"/usr/share/doc/${PF}/fceux{,-net-server}.6 || die # duplicate
	rm "${ED}"/usr/share/man/man6/fceux-net-server.6 || die # not used
}
