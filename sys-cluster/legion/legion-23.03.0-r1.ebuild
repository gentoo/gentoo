# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="Data-centric parallel programming system"
HOMEPAGE="https://legion.stanford.edu/"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/StanfordLegion/legion.git"
else
	SRC_URI="https://github.com/StanfordLegion/legion/archive/${P}.tar.gz"
	S="${WORKDIR}"/${PN}-${P}
	KEYWORDS="~amd64"
fi

LICENSE="BSD"
SLOT="0"
IUSE="examples gasnet test"
RESTRICT="!test? ( test )"

# https://github.com/StanfordLegion/legion/issues/575 re <hwloc-2
# See bug #821424 for examples/mpi
DEPEND="examples? ( virtual/mpi[cxx] )
	gasnet? ( >=sys-cluster/gasnet-1.26.4-r1 )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-gcc13.patch
)

src_configure() {
	# -Werror=odr
	# https://bugs.gentoo.org/863731
	# Fixed upstream / in live ebuild.
	filter-lto

	local mycmakeargs=(
		-DLegion_USE_HWLOC=OFF # security cleanup of <hwloc-2
		-DLegion_USE_GASNet=$(usex gasnet)
		-DLegion_ENABLE_TESTING=$(usex test)
		-DLegion_BUILD_EXAMPLES=$(usex examples)
		-DLegion_BUILD_TESTS=ON
		-DLegion_BUILD_TUTORIAL=ON
	)

	cmake_src_configure
}
