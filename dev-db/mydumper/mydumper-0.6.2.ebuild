# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils versionator

DESCRIPTION="A high-performance multi-threaded backup (and restore) toolset for MySQL and Drizzle"
HOMEPAGE="https://launchpad.net/mydumper"
SRC_URI="https://launchpad.net/mydumper/$(get_version_component_range 1-2)/${PV}/+download/${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="dev-libs/libpcre
	virtual/mysql
	dev-libs/glib:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( <dev-python/sphinx-1.3 )"

DOCS=( README )

src_prepare() {
	# respect user cflags; do not expand ${CMAKE_C_FLAGS} (!)
	sed -i -e 's:-Werror -O3 -g:${CMAKE_C_FLAGS}:' CMakeLists.txt
	# fix doc install path
	sed -i -e "s:share/doc/mydumper:share/doc/${PF}:" docs/CMakeLists.txt
}

src_configure() {
	mycmakeargs=( $(cmake-utils_use doc BUILD_DOCS) )

	cmake-utils_src_configure
}
