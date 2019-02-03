# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="C++ header-only library for Nearest Neighbor (NN) search wih KD-trees"
HOMEPAGE="https://github.com/jlblancoc/nanoflann"

if [[ ${PV} = *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://github.com/jlblancoc/nanoflann.git"
else
	SRC_URI="https://github.com/jlblancoc/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND="dev-cpp/eigen:3"
DEPEND="${RDEPEND}"

src_prepare() {
	cmake-utils_src_prepare

	# do not compile examples
	cmake_comment_add_subdirectory examples
}

src_test() {
	"${CMAKE_MAKEFILE_GENERATOR}" -C "${BUILD_DIR}" -j1 test
}
