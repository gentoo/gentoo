# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# shellcheck disable=SC2317
EAPI=8

ROCM_VERSION=${PV}
PYTHON_COMPAT=( python3_{10..13} python3_13t )

inherit cmake flag-o-matic python-r1 rocm

GTEST_COMMIT="b85864c64758dec007208e56af933fc3f52044ee"
GTEST_FILE="gtest-1.14.0_p20220421.tar.gz"

DESCRIPTION="High Performance Composable Kernel for AMD GPUs"
HOMEPAGE="https://github.com/ROCm/composable_kernel"
SRC_URI="https://github.com/ROCm/composable_kernel/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz
	test? ( https://github.com/google/googletest/archive/${GTEST_COMMIT}.tar.gz -> ${GTEST_FILE} )"
S="${WORKDIR}/composable_kernel-rocm-${PV}"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"

IUSE="debug profiler test"
REQUIRED_USE="${ROCM_REQUIRED_USE} ${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-util/hip:${SLOT}
	${PYTHON_DEPS}
"

DEPEND="${RDEPEND}"

BDEPEND="
	dev-build/rocm-cmake
"

PATCHES=(
	"${FILESDIR}"/${PN}-6.1.1-enable-examples.patch
	"${FILESDIR}"/${PN}-6.1.1-no-git-no-hash.patch
	"${FILESDIR}"/${PN}-6.3.0-no-inline-all.patch
	"${FILESDIR}"/${PN}-6.3.0-conditional-kernels.patch
	"${FILESDIR}"/${PN}-6.3.0-conditional-ckprofiler.patch
)

pkg_pretend() {
	targets=($AMDGPU_TARGETS)
	if [[ ${#targets[@]} -gt 1 ]]; then
		ewarn "composable-kernel will be compiled for multiple GPU architectures,"
		ewarn "which will take a significant amount of time."
		ewarn "Please consider setting AMDGPU_TARGETS USE_EXPAND variable to a single architecture."
	fi
}

src_prepare() {
	sed -e '/-Werror/d' -i cmake/EnableCompilerWarnings.cmake || die
	cmake_src_prepare
}

src_configure() {
	rocm_use_hipcc

	if ! use debug; then
		append-cflags "-DNDEBUG"
		append-cxxflags "-DNDEBUG"
		CMAKE_BUILD_TYPE="Release"
	else
		CMAKE_BUILD_TYPE="Debug"
	fi

	local mycmakeargs=(
		-DCMAKE_SKIP_RPATH=ON
		-DBUILD_DEV=OFF
		-DGPU_TARGETS="$(get_amdgpu_flags)"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DBUILD_TESTING=$(usex test ON OFF)
		-DCK_USE_PROFILER=$(usex profiler ON OFF)
		-Wno-dev
	)

	if use test; then
		mycmakeargs+=(
			-DFETCHCONTENT_SOURCE_DIR_GTEST="${WORKDIR}/googletest-${GTEST_COMMIT}"
		)
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install

	installation() {
		python_domodule python/ck4inductor

		# install package-data manually, as there is no PEP517 compliance
		shopt -s globstar
		package_data=(
			include/ck/**/*.hpp
			library/src/tensor_operation_instance/gpu/gemm_universal/**/*.hpp
		)
		shopt -u globstar

		inst_path="${D}$(python_get_sitedir)/ck4inductor"
		for file in "${package_data[@]}"; do
			location="${inst_path}/$(dirname "$file")"
			mkdir -p "${location}"
			cp "${file}" "${location}"
		done
	}
	python_foreach_impl installation
}

src_test() {
	check_amdgpu
	LD_LIBRARY_PATH="${BUILD_DIR}"/lib cmake_src_test -j1
}
