# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Argument Parser for Modern C++"
HOMEPAGE="https://github.com/p-ranav/argparse"
SRC_URI="https://github.com/p-ranav/argparse/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

src_prepare() {
	cmake_src_prepare
	sed -e 's/ -Werror//' -i test/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DARGPARSE_BUILD_TESTS=$(usex test)
	)

	cmake_src_configure
}

src_test() {
	cd "${BUILD_DIR}"/test || die
	./tests || die
}
