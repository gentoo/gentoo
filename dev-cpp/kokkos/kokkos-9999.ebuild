# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake cuda toolchain-funcs

DESCRIPTION="C++ Performance Portability Programming EcoSystem"
HOMEPAGE="https://github.com/kokkos"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/kokkos/kokkos.git"
else
	MY_PV="$(ver_cut 1-2).0$(ver_cut 3)"
	SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${MY_PV}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD"
SLOT="0/${PV}"
IUSE="cuda +openmp test"
RESTRICT="!test? ( test )"

DEPEND="sys-apps/hwloc:="
RDEPEND="${DEPEND}"

#
# Try to translate the "${CUDAARCHS}" number coming from __nvcc_device_query
# into an option string that Kokkos' CMake configuration understands:
#
kokkos_arch_option() {
	case "${1}" in
		3[0257]) echo "-DKokkos_ARCH_KEPLER${1}=ON"     ;;
		5[023])  echo "-DKokkos_ARCH_MAXWELL${1}=ON"    ;;
		6[01])   echo "-DKokkos_ARCH_PASCAL${1}=ON"     ;;
		7[02])   echo "-DKokkos_ARCH_VOLTA${1}=ON"      ;;
		75)      echo "-DKokkos_ARCH_TURING${1}=ON"     ;;
		8[06])   echo "-DKokkos_ARCH_AMPERE${1}=ON"     ;;
		89)      echo "-DKokkos_ARCH_ADA${1}=ON"        ;;
		90)      echo "-DKokkos_ARCH_HOPPER${1}=ON"     ;;
		1[02]0)  echo "-DKokkos_ARCH_BLACKWELL${1}=ON"  ;;
		*)       die "Unknown CUDA architecture »${1}«" ;;
	esac
}

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_INCLUDEDIR=include/kokkos
		-DKokkos_ENABLE_TESTS="$(usex test)"
		-DKokkos_ENABLE_AGGRESSIVE_VECTORIZATION=ON
		-DKokkos_ENABLE_SERIAL=ON
		-DKokkos_ENABLE_HWLOC=ON
		-DKokkos_ENABLE_CUDA="$(usex cuda)"
		-DKokkos_ENABLE_CUDA_CONSTEXPR="$(usex cuda)"
		-DKokkos_HWLOC_DIR="${EPREFIX}/usr"
		-DKokkos_ENABLE_OPENMP="$(usex openmp)"
		-DBUILD_SHARED_LIBS=ON
	)

	if use cuda; then
		cuda_add_sandbox -w

		if [[ ! -n "${CUDAARCHS}" ]]; then
			if ! SANDBOX_WRITE=/dev/nvidiactl test -w /dev/nvidiactl ; then
				eerror
				eerror "Can not access the GPU at /dev/nvidiactl."
				eerror "User $(id -nu) is not in the group \"video\"."
				eerror
				ewarn
				ewarn "Can not query the native device. You will need to set one of the"
				ewarn "supported Kokkos_ARCH_{..} CMake variables, or the CUDAARCHS"
				ewarn "environment variable to the appropriate architecture by hand..."
				ewarn
			else
				local CUDAARCHS
				CUDAARCHS="$(__nvcc_device_query || eerror "failed to query the native device")"
			fi
		fi

		if [[ -n "${CUDAARCHS}" ]]; then
			einfo "Building with CUDAARCHS=${CUDAARCHS}"
			mycmakeargs+=(
				$(kokkos_arch_option "${CUDAARCHS}")
			)
		fi
	fi

	cmake_src_configure
}

src_test() {
	local myctestargs=(
		# Contains "death tests" which are known/expected(?) to fail
		# https://github.com/kokkos/kokkos/issues/3033
		# bug #791514
		-E "(KokkosCore_UnitTest_OpenMP|KokkosCore_UnitTest_Serial)"
	)

	cmake_src_test
}
