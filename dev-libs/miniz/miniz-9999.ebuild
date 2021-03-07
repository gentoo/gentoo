# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="A lossless, high performance data compression library"
HOMEPAGE="https://github.com/richgel999/miniz"
SRC_URI=""

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/richgel999/miniz.git"
else
	SRC_URI="https://github.com/richgel999/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="examples static-libs"

DOCS=( ChangeLog.md LICENSE readme.md )

src_prepare() {
	sed -i -e 's/DESTINATION lib/DESTINATION ${CMAKE_INSTALL_LIBDIR}/' CMakeLists.txt

	cmake_src_prepare
}

src_configure() {
	CMAKE_BUILD_TYPE=Release

	local mycmakeargs=(
		-DBUILD_EXAMPLES=$(usex examples)
		-DBUILD_SHARED_LIBS=$(usex static-libs OFF ON)
	)

	cmake_src_configure
}
