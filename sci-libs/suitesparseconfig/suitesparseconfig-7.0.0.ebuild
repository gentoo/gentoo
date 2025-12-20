# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib toolchain-funcs

Sparse_PV=$(ver_rs 3 '.')
Sparse_P="SuiteSparse-${Sparse_PV}"
DESCRIPTION="Common configurations for all packages in suitesparse"
HOMEPAGE="https://people.engr.tamu.edu/davis/suitesparse.html"
SRC_URI="https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/refs/tags/v${Sparse_PV}.tar.gz -> ${Sparse_P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0/7"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="openmp"

# BLAS availability is checked for at configuration time and will fail if it is not present.
BDEPEND="virtual/blas"

S="${WORKDIR}/${Sparse_P}/SuiteSparse_config"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

multilib_src_configure() {
	# Make sure we always include the Fortran interface.
	# It doesn't require a Fortran compiler to be present
	# and simplifies the configuration for dependencies.
	local mycmakeargs=(
		-DNSTATIC=ON
		-DNFORTRAN=OFF
		-DNOPENMP=$(usex openmp OFF ON)
	)
	cmake_src_configure
}
