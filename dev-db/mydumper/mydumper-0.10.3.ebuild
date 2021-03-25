# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="A high-performance multi-threaded backup (and restore) toolset for MySQL"
HOMEPAGE="https://github.com/maxbube/mydumper"
SRC_URI="https://github.com/maxbube/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="app-arch/zstd
	dev-db/mysql-connector-c:=
	dev-libs/glib:=
	dev-libs/libpcre:=
	dev-libs/openssl:0=
	sys-libs/zlib:="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	doc? ( dev-python/sphinx )"

PATCHES=(
	"${FILESDIR}/${PN}-atomic.patch" #654314
)

src_prepare() {
	# respect user cflags; do not expand ${CMAKE_C_FLAGS} (!)
	sed -i -e 's|-Werror -O3 -g|${CMAKE_C_FLAGS}|' CMakeLists.txt || die

	# fix doc install path
	sed -i -e "s|share/doc/mydumper|share/doc/${PF}|" docs/CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=("-DBUILD_DOCS=$(usex doc)")

	cmake_src_configure
}
