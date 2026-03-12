# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-1 luajit )

inherit cmake lua-single virtualx

DESCRIPTION="An open-source Zelda-like 2D game engine"
HOMEPAGE="https://www.solarus-games.org/"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.com/solarus-games/solarus.git"
	EGIT_BRANCH="dev"
	inherit git-r3
else
	SRC_URI="https://gitlab.com/solarus-games/solarus/-/archive/v${PV}/solarus-v${PV}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="doc +editor"

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
	>=media-libs/sdl2-ttf-2.0.12
	editor? ( >=dev-qt/qlementine-1.4.0 )
"

DEPEND="
	${RDEPEND}
"

BDEPEND="
	doc? ( app-text/doxygen )
"

if ! [[ ${PV} == 9999 ]]; then
	S="${WORKDIR}/solarus-v${PV}"
fi

PATCHES=(
	"${FILESDIR}/solarus-2.0.3-system-qlementine.patch"
)

src_configure() {
	local mycmakeargs=( -DSOLARUS_USE_LUAJIT="$(usex lua_single_target_luajit)" )
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	if use doc ; then
		cd doc && doxygen || die
	fi
	if use editor ; then
		mycmakeargs+=(
			-DSOLARUS_USE_SYSTEM_QLEMENTINE=ON
			-DSOLARUS_USE_LOCAL_QLEMENTINE=OFF
		)
		cd editor && cmake_src_compile
	fi
}

src_test() {
	# lua/bugs-{1200,1210} are GUI tests that require X
	# With EAPI 8, one of the last tests hangs with >= j3
	virtx cmake_src_test -j1
}

src_install() {
	cmake_src_install
	use doc && dodoc -r doc/${PV%.*}/html/*
	use editor && cmake_src_install
}
