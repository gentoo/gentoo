# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8,10} )

inherit cmake prefix python-any-r1

DESCRIPTION="Callback/Activity Library for Performance tracing AMD GPU's"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/roctracer.git"
SRC_URI="https://github.com/ROCm-Developer-Tools/roctracer/archive/rocm-${PV}.tar.gz -> rocm-tracer-${PV}.tar.gz
		https://github.com/ROCm-Developer-Tools/rocprofiler/archive/rocm-${PV}.tar.gz -> rocprofiler-${PV}.tar.gz
		https://github.com/ROCmSoftwarePlatform/hsa-class/archive/f8b387043b9f510afdf2e72e38a011900360d6ab.tar.gz -> hsa-class-f8b3870.tar.gz"
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
	"${FILESDIR}"/${PN}-4.3.0-ldflag.patch
	"${FILESDIR}"/${PN}-4.3.0-tracer_tool.patch
	"${FILESDIR}"/${PN}-4.3.0-no-aqlprofile.patch
)

python_check_deps() {
	python_has_version "dev-python/CppHeaderParser[${PYTHON_USEDEP}]" \
		"dev-python/ply[${PYTHON_USEDEP}]"
}

src_prepare() {
	mv "${WORKDIR}"/rocprofiler-rocm-${PV} "${WORKDIR}"/rocprofiler || die
	mv "${WORKDIR}"/hsa-class-*/test/util "${S}"/inc/ || die
	rm "${S}"/inc/util/hsa* || die
	cp -a "${S}"/src/util/hsa* "${S}"/inc/util/ || die

	# do not build the tool and it´s library;
	# change destination for headers to include/roctracer;
	# do not install a second set of header files;

	sed -e "/LIBRARY DESTINATION/s,lib,$(get_libdir)," \
		-e "/DESTINATION/s,\${DEST_NAME}/include,include/roctracer," \
		-e "/install ( FILES \${PROJECT_BINARY_DIR}\/so/d" \
		-e "/DESTINATION/s,\${DEST_NAME}/lib64,$(get_libdir),g" \
		-i CMakeLists.txt || die

	# do not download additional sources via git
	sed -e "/execute_process ( COMMAND sh -xc \"if/d" \
		-e "/add_subdirectory ( \${HSA_TEST_DIR} \${PROJECT_BINARY_DIR}/d" \
		-e "/DESTINATION/s,\${DEST_NAME}/tool,$(get_libdir),g" \
		-i test/CMakeLists.txt || die

	hprefixify script/*.py

	cmake_src_prepare
}

src_configure() {
	export HIP_PATH="$(hipconfig -p)"

	local mycmakeargs=(
		-DHIP_VDI=1
		-DCMAKE_PREFIX_PATH="${EPREFIX}/usr/include/hsa:${EPREFIX}/usr/lib"
	)

	cmake_src_configure
}
