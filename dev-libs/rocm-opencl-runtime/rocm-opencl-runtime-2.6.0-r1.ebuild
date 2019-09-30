# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

OPENCL_ICD_COMMIT="bc9728edf8cace79cf33bf75560be88fc2432dc4"
SRC_URI="https://github.com/KhronosGroup/OpenCL-ICD-Loader/archive/${OPENCL_ICD_COMMIT}.tar.gz -> OpenCL-ICD-Loader-${OPENCL_ICD_COMMIT}.tar.gz"
if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime/"
	inherit git-r3
else
	SRC_URI+=" https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime/archive/roc-${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/ROCm-OpenCL-Runtime-roc-${PV}"
fi

DESCRIPTION="Radeon Open Compute OpenCL Compatible Runtime"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime"

LICENSE="Apache-2.0 MIT"
SLOT="0/$(ver_cut 1-2)"

RDEPEND="dev-libs/rocr-runtime
	dev-libs/rocm-comgr
	dev-libs/rocm-device-libs
	dev-libs/rocm-opencl-driver
	dev-libs/ocl-icd[khronos-headers]"
DEPEND="${RDEPEND}
	dev-lang/ocaml
	dev-ml/findlib"

PATCHES=(
	"${FILESDIR}/${P}-unbundle-dependencies.patch"
)

src_prepare() {
	mkdir -p "${S}"/api/opencl/khronos/ || die
	mv "${WORKDIR}/OpenCL-ICD-Loader-${OPENCL_ICD_COMMIT}" "${S}"/api/opencl/khronos/icd || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DLLVM_DIR="${EPREFIX}/usr/lib/llvm/roc/"
		-DClang_DIR="${EPREFIX}/usr/lib/llvm/roc/lib/cmake/clang/"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/"
	)
	cmake-utils_src_configure
}
