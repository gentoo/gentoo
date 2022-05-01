# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9} )

inherit cmake prefix python-any-r1

DESCRIPTION="Callback/Activity Library for Performance tracing AMD GPU's"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/roctracer.git"
SRC_URI="https://github.com/ROCm-Developer-Tools/roctracer/archive/rocm-${PV}.tar.gz -> rocm-tracer-${PV}.tar.gz
		https://github.com/ROCm-Developer-Tools/rocprofiler/archive/rocm-${PV}.tar.gz -> rocprofiler-${PV}.tar.gz"
S="${WORKDIR}/roctracer-rocm-${PV}"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"

RDEPEND="dev-libs/rocr-runtime:${SLOT}
	dev-util/hip:${SLOT}"
DEPEND="${RDEPEND}"
BDEPEND="
	$(python_gen_any_dep '
	dev-python/CppHeaderParser[${PYTHON_USEDEP}]
	dev-python/ply[${PYTHON_USEDEP}]
	')
"

PATCHES=(
	# https://github.com/ROCm-Developer-Tools/roctracer/pull/63
	"${FILESDIR}"/${PN}-4.3.0-glibc-2.34.patch
	"${FILESDIR}"/${PN}-5.0.2-Werror.patch
	"${FILESDIR}"/${PN}-5.0.2-headers.patch
	"${FILESDIR}"/${PN}-5.0.2-strip-license.patch
)

python_check_deps() {
	has_version "dev-python/CppHeaderParser[${PYTHON_USEDEP}]" &&
	has_version "dev-python/ply[${PYTHON_USEDEP}]"
}

src_prepare() {
	cmake_src_prepare

	mv "${WORKDIR}"/rocprofiler-rocm-${PV} "${WORKDIR}"/rocprofiler || die

	sed -e "/LIBRARY DESTINATION/s,lib,$(get_libdir)," \
		-e "/add_subdirectory ( \${TEST_DIR} \${PROJECT_BINARY_DIR}/d" \
		-e "/install ( FILES \${PROJECT_BINARY_DIR}\/so/d" \
		-i CMakeLists.txt || die

	# do not download additional sources via git
	sed -e "/execute_process ( COMMAND sh -xc \"if/d" \
		-e "/add_subdirectory ( \${HSA_TEST_DIR} \${PROJECT_BINARY_DIR}/d" \
		-i test/CMakeLists.txt || die

	hprefixify script/*.py
}

src_configure() {
	export HIP_PATH="${EPREFIX}/usr"

	local mycmakeargs=(
		-DCMAKE_PREFIX_PATH="${EPREFIX}/usr/include/hsa"
	)

	cmake_src_configure
}
