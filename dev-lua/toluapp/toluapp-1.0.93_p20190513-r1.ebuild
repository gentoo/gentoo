# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

MY_PN=${PN/pp/++}
COMMIT_ID="b34075b76835b778bb6b2ce0aa224afd9d182887"

DESCRIPTION="A tool to integrate C/C++ code with Lua"
HOMEPAGE="https://github.com/LuaDist/toluapp"
SRC_URI="https://github.com/LuaDist/toluapp/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="=dev-lang/lua-5.1*:=[deprecated]"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}-${COMMIT_ID}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.93_p20190513-fix-multilib.patch
)
CMAKE_REMOVE_MODULES_LIST="dist.cmake lua.cmake FindLua.cmake"
