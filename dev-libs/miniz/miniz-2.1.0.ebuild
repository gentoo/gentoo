# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="A lossless, high performance data compression library"
HOMEPAGE="https://github.com/richgel999/miniz"
SRC_URI="https://github.com/richgel999/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DOCS=( ChangeLog.md LICENSE readme.md )

src_prepare() {
	sed -i -e 's/DESTINATION lib/DESTINATION ${CMAKE_INSTALL_LIBDIR}/' CMakeLists.txt

	cmake_src_prepare
}

src_configure() {
	CMAKE_BUILD_TYPE=Release

	cmake_src_configure
}
