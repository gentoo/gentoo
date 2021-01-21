# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake prefix

DESCRIPTION="Callback/Activity Library for Performance tracing AMD GPU's"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/roctracer.git"
SRC_URI="https://github.com/ROCm-Developer-Tools/roctracer/archive/rocm-${PV}.tar.gz -> rocm-tracer-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-libs/rocr-runtime
	 sys-devel/llvm-roc
	 dev-util/hip"
DEPEND="dev-python/CppHeaderParser
	dev-python/ply
	${RDEPEND}"

PATCHES=(
	"${FILESDIR}/roctracer-3.8.0-gen_ostream_ops-toPython3.patch"
)

S="${WORKDIR}/roctracer-rocm-${PV}"

src_prepare() {
	# do not build the tool and it´s library;
	# change destination for headers to include/roctracer;
	# do not install a second set of header files;
	sed -e "/LIBRARY DESTINATION/s,lib,$(get_libdir)," \
		-e "/add_subdirectory ( \${TEST_DIR} \${PROJECT_BINARY_DIR}/d" \
		-e "/DESTINATION/s,\${DEST_NAME}/include,include/roctracer," \
		-e "/install ( FILES \${CMAKE_CURRENT_SOURCE_DIR}/d" \
		-e "/install ( FILES \${PROJECT_BINARY_DIR}/d" \
		-i CMakeLists.txt || die

	# do not download additional sources via git
	sed -e "/execute_process ( COMMAND sh -xc \"if/d" \
		-e "/add_subdirectory ( \${TEST_DIR} \${PROJECT_BINARY_DIR}/d" \
		-i test/CMakeLists.txt || die

	hprefixify script/*.py

	eapply_user
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DHIP_VDI=1
		-DCMAKE_PREFIX_PATH="${EPREFIX}/usr/include/hsa:${EPREFIX}/usr/lib"
	)

	cmake_src_configure
}
