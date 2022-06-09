# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake toolchain-funcs

DESCRIPTION="Numerical linear algebra software package"
HOMEPAGE="https://ginkgo-project.github.io/"
SRC_URI="https://github.com/${PN}-project/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64"
LICENSE="BSD-with-attribution"
SLOT="0"
IUSE="cuda hip hwloc mixed-precision +openmp"

RDEPEND="
	cuda? ( dev-util/nvidia-cuda-toolkit )
	hip? (
		dev-util/hip
		sci-libs/hipBLAS
		sci-libs/hipFFT
		sci-libs/hipSPARSE
		sci-libs/rocRAND
		sci-libs/rocThrust
	)
	hwloc? ( sys-apps/hwloc:= )
"
DEPEND="${RDEPEND}"

pkg_pretend() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

pkg_setup() {
	[[ ${MERGE_TYPE} != binary ]] && use openmp && tc-check-openmp
}

src_prepare() {
	sed -i \
		-e "s#\"lib\"#\"$(get_libdir)\"#g" \
		-e "s#\"lib/#\"$(get_libdir)/#g" \
		cmake/install_helpers.cmake || die "sed failed"

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DGINKGO_BUILD_BENCHMARKS=OFF
		-DGINKGO_BUILD_DPCPP=OFF
		-DGINKGO_BUILD_REFERENCE=ON
		-DGINKGO_BUILD_TESTS=OFF
		-DGINKGO_DEVEL_TOOLS=OFF
		-DGINKGO_BUILD_CUDA=$(usex cuda)
		-DGINKGO_BUILD_HIP=$(usex hip)
		-DGINKGO_BUILD_HWLOC=$(usex hwloc)
		-DGINKGO_BUILD_OMP=$(usex openmp)
		-DGINKGO_MIXED_PRECISION=$(usex mixed-precision)
	)
	if use hip; then
		addpredict /dev/kfd
		mycmakeargs+=(
			-DHIP_CLANG_PATH="${EPREFIX}/usr/lib/llvm/roc"
			-DHIP_PATH="${EPREFIX}/usr/$(get_libdir)"
			-DHIP_ROOT_DIR="${EPREFIX}/usr"
			-DHIPFFT_PATH="${EPREFIX}/usr/hipfft"
			-DROCM_PATH="${EPREFIX}/usr"
		)
	fi
	cmake_src_configure
}
