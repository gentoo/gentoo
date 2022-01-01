# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Newer Lua versions are NOT supported, see Bug #508222
LUA_COMPAT=( lua5-1 )

inherit cmake lua-single

MY_PN=${PN/pp/++}
COMMIT_ID="b34075b76835b778bb6b2ce0aa224afd9d182887"

DESCRIPTION="A tool to integrate C/C++ code with Lua"
HOMEPAGE="https://github.com/LuaDist/toluapp"
SRC_URI="https://github.com/LuaDist/toluapp/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"

REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="${LUA_DEPS}"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-${COMMIT_ID}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.93_p20190513-fix-multilib.patch
	"${FILESDIR}"/${PN}-1.0.93_p20190513-lua-version.patch
)
CMAKE_REMOVE_MODULES_LIST="dist lua FindLua"

src_configure() {
	local mycmakeargs=(
		-DLUA_VERSION=$(ver_cut 1-2 $(lua_get_version))
	)
	cmake_src_configure
}
