# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Interactive TUI S.M.A.R.T viewer"
HOMEPAGE="https://github.com/otakuto/crazydiskinfo"
SRC_URI="https://github.com/otakuto/crazydiskinfo/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-libs/libatasmart:0=
	sys-libs/ncurses:0="

RDEPEND="${DEPEND}"

src_prepare() {
	sed -e "s#^set(CMAKE_CXX_FLAGS.*#set(CMAKE_CXX_FLAGS \"${CXXFLAGS} -Wall -std=c++11\")#" \
		-e "5s#^#set(CMAKE_C_FLAGS \"${CFLAGS}\")\n#" \
		-i CMakeLists.txt || die "can't patch CMakeLists.txt"

	cmake-utils_src_prepare
}
