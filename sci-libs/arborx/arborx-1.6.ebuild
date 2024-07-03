# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Library for performance portable algorithms for geometric search"
HOMEPAGE="https://github.com/arborx/ArborX"

SRC_URI="https://github.com/${PN}/ArborX/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="mpi"

RDEPEND="dev-libs/boost:=
	mpi? ( virtual/mpi[cxx] )
	sci-libs/trilinos"

DEPEND="${RDEPEND}"

S="${WORKDIR}"/ArborX-${PV}

src_prepare() {
	cmake_src_prepare

	# replace hardcoded "lib/" directory:
	sed -i -e "s#lib/#$(get_libdir)/#g" CMakeLists.txt || die "sed failed"
}

src_configure() {
	local mycmakeargs=(
		-DARBORX_ENABLE_MPI="$(usex mpi)"
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
}
