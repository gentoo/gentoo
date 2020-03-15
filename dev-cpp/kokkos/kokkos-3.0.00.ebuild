# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils toolchain-funcs

DESCRIPTION="Kokkos C++ Performance Portability Programming EcoSystem"
HOMEPAGE="https://github.com/kokkos"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+openmp test"
RESTRICT="!test? ( test )"

DEPEND="
	sys-apps/hwloc
	"
RDEPEND="${DEPEND}"
BDEPEND=""

pkg_setup() {
	if [[ ${MERGE_TYPE} != binary ]] && \
		use openmp && ! tc-has-openmp ; then
			die "Need an OpenMP capable compiler"
	fi
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_INCLUDEDIR=include/kokkos
		-DKokkos_ENABLE_TESTS=$(usex test)
		-DKokkos_ENABLE_AGGRESSIVE_VECTORIZATION=ON
		-DKokkos_ENABLE_DEPRECATED_CODE=ON
		-DKokkos_ENABLE_SERIAL=ON
		-DKokkos_ENABLE_HWLOC=ON
		-DKokkos_HWLOC_DIR="${EPREFIX}/usr"
		-DKokkos_ENABLE_OPENMP=$(usex openmp)
		-DBUILD_SHARED_LIBS=ON
	)

	cmake-utils_src_configure
}
