# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="Split an MPI communicator into subcomms based on string values"
HOMEPAGE="https://github.com/ECP-VeloC/rankstr"
SRC_URI="https://github.com/ECP-VeloC/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="mpi test"
RESTRICT="!test? ( test )"

RDEPEND="
	mpi? ( virtual/mpi )
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-util/cmake-2.8
"

src_prepare() {
	#do not build static library
	sed -i '/rankstr-static/d' src/CMakeLists.txt || die
	default
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DMPI="$(usex mpi "" OFF)"
	)
	cmake-utils_src_configure
}
