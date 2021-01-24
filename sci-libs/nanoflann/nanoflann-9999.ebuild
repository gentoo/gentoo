# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

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
IUSE="examples test"
RESTRICT="!test? ( test )"

RDEPEND="dev-cpp/eigen:3"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DBUILD_EXAMPLES=$(usex examples)
		-DBUILD_TESTS=$(usex test)
	)
	cmake_src_configure
}
