# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Interactive memory viewer"
HOMEPAGE="https://unixdev.ru/memwatch"
SRC_URI="http://unixdev.ru/src/${P}.tar.gz"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-libs/ncurses:0="
RDEPEND="${DEPEND}"

CMAKE_REMOVE_MODULES_LIST="FindCurses"

src_prepare() {
	sed -e "s/^set(CMAKE_C_FLAGS.*/set(CMAKE_C_FLAGS \"${CFLAGS}\")/" \
		-e "1s/^/project(${PN})\n/" \
		-i CMakeLists.txt || die "can't patch CMakeLists.txt"

	cmake-utils_src_prepare
}
