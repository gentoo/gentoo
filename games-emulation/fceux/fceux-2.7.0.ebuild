# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-1 )
inherit cmake lua-single xdg

DESCRIPTION="Portable Famicom/NES emulator, an evolution of the original FCE Ultra"
HOMEPAGE="https://fceux.com/"
SRC_URI="https://github.com/TASEmulators/fceux/archive/refs/tags/${P}.tar.gz"
S=${WORKDIR}/${PN}-${P}

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="archive ffmpeg javascript vulkan x264 x265"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	${LUA_DEPS}
	dev-qt/qtbase:6[gui,network,opengl,vulkan?,widgets,-gles2-only]
	dev-qt/qttools:6[assistant,widgets]
	media-libs/libglvnd
	media-libs/libsdl2[joystick,sound,threads(+),video]
	virtual/minizip:=
	archive? ( app-arch/libarchive:= )
	ffmpeg? ( media-video/ffmpeg:= )
	javascript? ( dev-qt/qtdeclarative:6 )
	vulkan? ( media-libs/vulkan-loader )
	x264? ( media-libs/x264:= )
	x265? ( media-libs/x265:= )
"
DEPEND="
	${RDEPEND}
	vulkan? ( dev-util/vulkan-headers )
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.4.0-desktop.patch
	"${FILESDIR}"/${PN}-2.4.0-no-git.patch
	"${FILESDIR}"/${PN}-2.6.6-no-glx.patch
)

src_prepare() {
	rm -r attic || die # unused files, triggers QA warnings (bug #958954)

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
		-DGLVND=ON
		-DPUBLIC_RELEASE=ON
		-DQT6=ON
		$(cmake_use_find_package javascript Qt6Qml)
		$(cmake_use_find_package vulkan Vulkan)
	)

	cmake_src_configure
}

src_install() {
	local DOCS=( README TODO-SDL changelog.txt documentation/. readme.md )
	cmake_src_install

	rm -- "${ED}"/usr/share/doc/${PF}/fceux{,-net-server}.6 || die # duplicate
	rm -- "${ED}"/usr/share/man/man6/fceux-net-server.6 || die # not used
}
