# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="'top' for PostgreSQL"
HOMEPAGE="https://pg_top.gitlab.io/"
SRC_URI="https://pg_top.gitlab.io/source/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-db/postgresql:=
	dev-libs/libbsd
	sys-libs/ncurses:=
	virtual/libelf:="
DEPEND="${RDEPEND}"

DOCS=( HISTORY.rst README.rst TODO Y2K )

src_prepare() {
	sed 's/set(CMAKE_C_FLAGS "-Wall")//' -i CMakeLists.txt || die
	cmake_src_prepare
}
