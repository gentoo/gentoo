# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..14} )
ROCM_SKIP_GLOBALS=1
inherit cmake linux-info python-r1 rocm

ESMI_PN=esmi_pkg_ver
ESMI_PV=4.2

DESCRIPTION="AMD System Management Interface for managing and monitoring GPUs"
HOMEPAGE="
	https://github.com/ROCm/amdsmi
	https://rocm.docs.amd.com/projects/amdsmi/en/latest/
"
SRC_URI="
	https://github.com/ROCm/amdsmi/archive/refs/tags/rocm-${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/amd/esmi_ib_library/archive/refs/tags/${ESMI_PN}-${ESMI_PV}.tar.gz
"
S="${WORKDIR}/amdsmi-rocm-${PV}"
ESMI_S="${WORKDIR}/esmi_ib_library-${ESMI_PN}-${ESMI_PV}"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"

IUSE="test"
RESTRICT="!test? ( test )"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	${PYTHON_DEPS}
	test? ( dev-cpp/gtest )
	x11-libs/libdrm[video_cards_amdgpu]
"
RDEPEND="
	${PYTHON_DEPS}
	dev-libs/rocm-core:${SLOT}
"

PATCHES=(
	"${FILESDIR}"/${PN}-7.0.2-no-git.patch
	"${FILESDIR}"/${PN}-7.0.2-unbundle-gtest.patch
	"${FILESDIR}"/${PN}-7.1.1-libdrm-compat.patch
)

CONFIG_CHECK="~HSA_AMD ~DRM_AMDGPU"

src_prepare() {
	ln -s "${ESMI_S}" esmi_ib_library || die

	# Compatibility with CMake < 3.10 will be removed
	sed -e "/cmake_minimum_required/ s/3\.5\.0/3.10/" \
		-i goamdsmi_shim/CMakeLists.txt "${ESMI_S}"/CMakeLists.txt || die

	sed -e "s/-Wall -Wextra//" \
		-i CMakeLists.txt "${ESMI_S}"/CMakeLists.txt goamdsmi_shim/CMakeLists.txt || die

	# Reset custom installation path
	sed -e "/generic_add_rocm/d" -i CMakeLists.txt || die

	# Remove /usr/lib to fix multilib
	sed -e '/target_link_libraries.*\/lib/d' -i goamdsmi_shim/CMakeLists.txt || die

	# Install docs to correct place
	sed -e "s:doc/\${CPACK_PACKAGE_NAME}:doc/${P}:" -i CMakeLists.txt || die

	# Do not install /usr/share/doc/${P}-asan
	sed -e "s/COMPONENT asan/COMPONENT asan EXCLUDE_FROM_ALL/" -i CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	python_setup

	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)
		-DUSE_SYSTEM_GTEST=ON
		-Wno-dev
	)
	cmake_src_configure
}

src_test() {
	# GPU access in amdsmitstReadOnly.TestSysInfoRead and amdsmitstReadOnly.TestIdInfoRead
	addwrite /dev/dri/renderD128

	# Few tests fail on ASUS GZ302E: no metrics from kernel?
	GTEST_FILTER="-amdsmitstReadOnly.TempRead:amdsmitstReadOnly.TestFrequenciesRead" \
	"${BUILD_DIR}/tests/amd_smi_test/amdsmitst" || die "Test failed"
}

src_install() {
	cmake_src_install

	# Wrong places
	rm "${ED}"/usr/share/amd_smi/amdsmi/{libamd_smi.so,LICENSE,README.md} || die

	python_fix_shebang "${ED}"/usr/libexec/amdsmi_cli
	python_domodule "${ED}"/usr/libexec/amdsmi_cli
	python_domodule "${ED}"/usr/share/amd_smi/amdsmi

	fperms a+x "/usr/lib/${EPYTHON}/site-packages/amdsmi_cli/amdsmi_cli.py"
	dosym -r "/usr/lib/${EPYTHON}/site-packages/amdsmi_cli/amdsmi_cli.py" /usr/bin/amd-smi

	rm -rf "${ED}"/usr/share/amd_smi "${ED}"/usr/libexec/amdsmi_cli || die
}
