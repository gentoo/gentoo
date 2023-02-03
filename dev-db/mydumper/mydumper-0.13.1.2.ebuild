# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit cmake

MY_PV="$(ver_rs 3 -)"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="A high-performance multi-threaded backup (and restore) toolset for MySQL"
HOMEPAGE="https://github.com/maxbube/mydumper"
SRC_URI="https://github.com/maxbube/mydumper/archive/v${MY_PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="app-arch/zstd
	dev-db/mysql-connector-c:=
	dev-libs/glib:2
	dev-libs/libpcre
	dev-libs/openssl:=
	sys-libs/zlib:="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	doc? ( dev-python/sphinx )"

PATCHES=(
	"${FILESDIR}/${PN}-0.13.1-atomic.patch" #654314
)

src_prepare() {
	# respect user cflags; do not expand ${CMAKE_C_FLAGS} (!)
	sed -i -e 's|-O3 -g -Werror|${CMAKE_C_FLAGS}|' CMakeLists.txt || die

	# fix doc install path
	sed -i -e "s|share/doc/mydumper|share/doc/${PF}|" docs/CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(-DBUILD_DOCS=$(usex doc))

	cmake_src_configure
}
