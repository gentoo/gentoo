# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake cuda flag-o-matic toolchain-funcs
MY_PV=$(ver_cut 1-2)
PV_BUILD="-35015278"

DESCRIPTION="NVIDIA Ray Tracing Engine"
HOMEPAGE="https://developer.nvidia.com/rtx/ray-tracing/optix"
SRC_URI="
	!headers-only? (
		amd64? (
			https://developer.download.nvidia.com/designworks/optix/secure/${PV}/NVIDIA-OptiX-SDK-${PV}-linux64-x86_64${PV_BUILD}.sh
		)
		arm64? (
			https://developer.download.nvidia.com/designworks/optix/secure/${PV}/NVIDIA-OptiX-SDK-${PV}-linux64-aarch64${PV_BUILD}.sh
		)
	)
	headers-only? (
		https://github.com/NVIDIA/optix-dev/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	)
"
S="${WORKDIR}"

LICENSE="NVIDIA-SDK"
SLOT="0/$(ver_cut 1)"
KEYWORDS="~amd64 ~arm64"
IUSE="+headers-only"
RESTRICT="bindist mirror !headers-only? ( fetch ) test"

RDEPEND=">=x11-drivers/nvidia-drivers-555"

pkg_nofetch() {
	einfo "Please download ${A} from:"
	einfo "  ${HOMEPAGE}"
	einfo "and move it to your distfiles directory."
}

src_unpack() {
	if use headers-only; then
		default
	else
		skip="$(grep -a ^tail "${DISTDIR}/${A}" | tail -n1 | cut -d' ' -f 3)"
		tail -n "${skip}" "${DISTDIR}/${A}" | tar -zx -f -
		assert "unpacking ${A} failed"
	fi
}

src_prepare() {
	if use headers-only; then
		default
	else
		export CMAKE_USE_DIR="${WORKDIR}/SDK"
		sed -e "s/CMAKE_CXX_STANDARD 11/CMAKE_CXX_STANDARD 17/" -i "SDK/CMakeLists.txt" || die

		cmake_src_prepare
	fi
}

src_configure() {
	use headers-only && return

	filter-lto

	# cmake-4 #951350
	: "${CMAKE_POLICY_VERSION_MINIMUM:=3.10}"
	export CMAKE_POLICY_VERSION_MINIMUM

	# allow slotted install
	: "${CUDA_PATH:=${ESYSROOT}/opt/cuda}"
	export CUDA_PATH

	local -x CUDAHOSTCXX="$(cuda_gccdir)"
	local -x CUDAHOSTLD="$(tc-getCXX)"
	local mycmakeargs=(
		-DCUDA_HOST_COMPILER="$(cuda_gccdir)"
		-DGLFW_INSTALL="no"
		-DCUDA_CHECK_DEPENDENCIES_DURING_COMPILE="yes"
		-DOPTIX_OPTIXIR_BUILD_CONFIGURATION="${CMAKE_BUILD_TYPE}"
	)

	if [[ -v CUDAARCHS ]]; then
		local optix_CUDAARCHS="$(echo "${CUDAARCHS}" | tr ';' '\n' | sort | head -n1)"

		mycmakeargs+=(
			-DCUDA_MIN_SM_TARGET="sm_${optix_CUDAARCHS}"
			-DCUDA_MIN_SM_COMPUTE_TARGET="compute_${optix_CUDAARCHS}"
		)
	fi

	cmake_src_configure
}

src_compile() {
	use headers-only && return

	cmake_src_compile
}

src_test() {
	use headers-only && return

	cmake_src_test
}

src_install() {
	insinto "/opt/${PN}"

	if use headers-only; then
		cd "${PN}-dev-${PV}" || die
		doins -r include/

		dodoc README.md
		return
	fi

	# missing a install target so cmake_src_install fails
	cmake_run_in "${BUILD_DIR}" cmake -P cmake_install.cmake

	local DOCS=( "doc/OptiX_"{API_Reference,Programming_Guide}"_${PV}.pdf" )
	einstalldocs
}
