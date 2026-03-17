# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-1 luajit )

inherit cmake lua-single xdg-utils

DESCRIPTION="Quest editor for Solarus game engine"
HOMEPAGE="https://www.solarus-games.org/"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.com/solarus-games/solarus.git"
	EGIT_BRANCH="dev"
	inherit git-r3
else
	SRC_URI="https://gitlab.com/solarus-games/solarus/-/archive/v${PV}/solarus-v${PV}.tar.bz2"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3+"
SLOT="0"

REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	${LUA_DEPS}
	dev-games/physfs
	dev-qt/qtbase[gui,widgets]
	media-libs/libmodplug
	>=media-libs/libsdl2-2.0.1[X,joystick,video]
	media-libs/libvorbis
	media-libs/openal
	media-libs/sdl2-image[png]
	>=dev-qt/qlementine-1.4.0
	~games-engines/solarus-${PV}
"

DEPEND="
	${RDEPEND}
"

if ! [[ ${PV} == 9999 ]]; then
	S="${WORKDIR}/solarus-v${PV}"
fi

PATCHES=(
	"${FILESDIR}/solarus-2.0.3-system-qlementine.patch"
)

CMAKE_USE_DIR=${S}/editor

src_configure() {
	local mycmakeargs=(
		-DSOLARUS_USE_SYSTEM_QLEMENTINE=ON
		-DSOLARUS_USE_LOCAL_QLEMENTINE=OFF
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	cmake_src_install
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
