# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A data-centric parallel programming system"
HOMEPAGE="https://legion.stanford.edu/"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://StanfordLegion/${PN}.git https://github.com/StanfordLegion/${PN}.git"
else
	SRC_URI="https://github.com/StanfordLegion/${PN}/archive/${P}.tar.gz"
	S="${WORKDIR}"/${PN}-${P}

	KEYWORDS="~amd64"
fi

LICENSE="BSD"
SLOT="0"
IUSE="examples gasnet hwloc test"
RESTRICT="!test? ( test )"

# https://github.com/StanfordLegion/legion/issues/575 re <hwloc-2
# See bug #821424 for examples/mpi
DEPEND="examples? ( virtual/mpi[cxx] )
	gasnet? ( >=sys-cluster/gasnet-1.26.4-r1 )
	hwloc? ( <sys-apps/hwloc-2:= )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-23.03.0-gcc13.patch
)

src_configure() {
	local mycmakeargs=(
		-DLegion_USE_HWLOC=$(usex hwloc)
		-DLegion_USE_GASNet=$(usex gasnet)
		-DLegion_ENABLE_TESTING=$(usex test)
		-DLegion_BUILD_EXAMPLES=$(usex examples)
		-DLegion_BUILD_TESTS=ON
		-DLegion_BUILD_TUTORIAL=ON
	)

	cmake_src_configure
}
