# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="A high-performance multi-threaded backup (and restore) toolset for MySQL"
HOMEPAGE="https://github.com/maxbube/mydumper"
SRC_URI="https://github.com/maxbube/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

COMMON_DEPEND="dev-db/mysql-connector-c:=
	dev-libs/glib:=
	dev-libs/libpcre:=
	dev-libs/openssl:=
	sys-libs/zlib:="
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
	doc? ( dev-python/sphinx )"
RDEPEND="${COMMON_DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-atomic.patch" #654314
)

src_prepare() {
	# respect user cflags; do not expand ${CMAKE_C_FLAGS} (!)
	sed -i -e 's:-Werror -O3 -g:${CMAKE_C_FLAGS}:' CMakeLists.txt || die

	# fix doc install path
	sed -i -e "s:share/doc/mydumper:share/doc/${PF}:" docs/CMakeLists.txt || die

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=("-DBUILD_DOCS=$(usex doc)")

	cmake-utils_src_configure
}
