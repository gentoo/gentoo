# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="C++ header-only library for Nearest Neighbor (NN) search wih KD-trees"
HOMEPAGE="https://github.com/jlblancoc/nanoflann"
SRC_URI="https://github.com/jlblancoc/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-cpp/eigen:*"
DEPEND="${RDEPEND}"

src_prepare() {
	eapply_user

	# do not compile examples
	sed -ie 's/add_subdirectory(examples)//g' CMakeLists.txt || die "sed failed"
}

src_test() {
	cd "${BUILD_DIR}" && emake -j1 test
}

src_compile() {
	:
}
