# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9} )

inherit cmake prefix python-any-r1

DESCRIPTION="Callback/Activity Library for Performance tracing AMD GPU's"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/roctracer.git"
SRC_URI="https://github.com/ROCm-Developer-Tools/roctracer/archive/rocm-${PV}.tar.gz -> rocm-tracer-${PV}.tar.gz
		https://github.com/ROCm-Developer-Tools/rocprofiler/archive/rocm-${PV}.tar.gz -> rocprofiler-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"

RDEPEND="dev-libs/rocr-runtime:${SLOT}
	dev-util/hip:${SLOT}"
DEPEND="dev-python/CppHeaderParser
	dev-python/ply
	${RDEPEND}"

S="${WORKDIR}/roctracer-rocm-${PV}"

src_prepare() {
	mv "${WORKDIR}"/rocprofiler-rocm-${PV} "${WORKDIR}"/rocprofiler || die

	# do not build the tool and it´s library;
	# change destination for headers to include/roctracer;
	# do not install a second set of header files;

	sed -e "/LIBRARY DESTINATION/s,lib,$(get_libdir)," \
		-e "/add_subdirectory ( \${TEST_DIR} \${PROJECT_BINARY_DIR}/d" \
		-e "/DESTINATION/s,\${DEST_NAME}/include,include/roctracer," \
		-e "/install ( FILES \${PROJECT_BINARY_DIR}/d" \
		-e "/DESTINATION/s,\${DEST_NAME}/lib64,$(get_libdir)/roctracer,g" \
		-i CMakeLists.txt || die

	# do not download additional sources via git
	sed -e "/execute_process ( COMMAND sh -xc \"if/d" \
		-e "/add_subdirectory ( \${HSA_TEST_DIR} \${PROJECT_BINARY_DIR}/d" \
		-i test/CMakeLists.txt || die

	hprefixify script/*.py

	eapply_user
	cmake_src_prepare
}

src_configure() {
	export HIP_PATH="${EPREFIX}/usr/lib/hip"

	local mycmakeargs=(
		-DHIP_VDI=1
		-DCMAKE_PREFIX_PATH="${EPREFIX}/usr/include/hsa:${EPREFIX}/usr/lib"
	)

	cmake_src_configure
}
