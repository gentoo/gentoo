# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-1 luajit )

inherit cmake lua-single

DESCRIPTION="A graphical user interface to create and modify quests for the Solarus engine"
HOMEPAGE="https://www.solarus-games.org"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.com/solarus-games/solarus-quest-editor.git"
	EGIT_BRANCH="dev"
	inherit git-r3
else
	SRC_URI="https://gitlab.com/solarus-games/solarus-quest-editor/-/archive/v${PV}/solarus-quest-editor-v${PV}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/solarus-quest-editor-v${PV}"
fi

LICENSE="GPL-3+"
SLOT="0"

REQUIRED_USE="${LUA_REQUIRED_USE}"

# Upstream (and their CMake) claim that all of these are required deps
RDEPEND="
	${LUA_DEPS}
	dev-games/physfs
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	media-libs/libmodplug
	>=media-libs/libsdl2-2.0.1[X,joystick,video]
	media-libs/libvorbis
	media-libs/openal
	media-libs/sdl2-image[png]
	>=media-libs/sdl2-ttf-2.0.12
"

DEPEND="
	${RDEPEND}
	~games-engines/solarus-${PV}
"

PATCHES=(
	"${FILESDIR}/${P}-fix-segfault.patch"
)

src_configure() {
	local mycmakeargs=( -DSOLARUS_USE_LUAJIT="$(usex lua_single_target_luajit)" )
	cmake_src_configure
}
