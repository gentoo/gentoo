# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..15} )
ROCM_SKIP_GLOBALS=1
inherit cmake dot-a linux-info python-r1 rocm toolchain-funcs

ESMI_PN=esmi_pkg_ver
ESMI_PV=5.2.1.1

DESCRIPTION="AMD System Management Interface for managing and monitoring GPUs"
HOMEPAGE="
	https://github.com/ROCm/rocm-systems/tree/develop/projects/amdsmi
	https://rocm.docs.amd.com/projects/amdsmi/en/latest/
"
SRC_URI="
	https://github.com/ROCm/rocm-systems/releases/download/therock-${PV%.0}/${PN}.tar.gz -> ${P}.tar.gz
	https://github.com/amd/esmi_ib_library/archive/refs/tags/${ESMI_PN}-${ESMI_PV}.tar.gz
		-> esmi_ib_library-${ESMI_PV}.tar.gz
"
S="${WORKDIR}/${PN}"
ESMI_S="${WORKDIR}/esmi_ib_library-${ESMI_PN}-${ESMI_PV}"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"

IUSE="test"
RESTRICT="!test? ( test )"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	dev-libs/libnl:3
	net-libs/libmnl
	x11-libs/libdrm[video_cards_amdgpu]
"
DEPEND="
	${RDEPEND}
	dev-libs/rocm-core:${SLOT}
	test? ( dev-cpp/gtest )
"

CONFIG_CHECK="~HSA_AMD ~DRM_AMDGPU"

src_prepare() {
	ln -s "${ESMI_S}" esmi_ib_library || die

	# Compatibility with CMake < 3.10 will be removed
	sed -e "/cmake_minimum_required/ s/3\.5\.0/3.10/" \
		-i goamdsmi_shim/CMakeLists.txt "${ESMI_S}"/CMakeLists.txt || die

	sed -e "s/-Wall -Wextra//" \
		-i CMakeLists.txt "${ESMI_S}"/CMakeLists.txt goamdsmi_shim/CMakeLists.txt || die

	# Bug: https://bugs.gentoo.org/984514
	sed -e "/check_cxx_compiler_flag/!s/ -Werror\(=[a-z-]*\)\?//g" \
		-i CMakeLists.txt cmake_modules/help_package.cmake \
		src/nic/ai-nic/amdsmi_unified/CMakeLists.txt || die

	# Bug: https://bugs.gentoo.org/984513
	sed -e "s/COMMAND objdump/COMMAND $(tc-getOBJDUMP)/" -i CMakeLists.txt || die

	# Reset custom installation path
	sed -e "/generic_add_rocm/d" -i CMakeLists.txt || die

	# Install docs to correct place
	sed -e "s:doc/\${CPACK_PACKAGE_NAME}:doc/${P}:" -i CMakeLists.txt || die

	# Do not install /usr/share/doc/${P}-asan
	sed -e "s/COMPONENT asan/COMPONENT asan EXCLUDE_FROM_ALL/" -i CMakeLists.txt || die

	# libc++ does not include <cstdlib> transitively
	sed -e "/#include <cstring>/i #include <cstdlib>" -i rocm_smi/src/rocm_smi_binary_parser.cc || die

	cmake_src_prepare
}

src_configure() {
	python_setup
	# Bug: https://bugs.gentoo.org/984518
	lto-guarantee-fat

	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)
		-Wno-dev
	)
	use test && mycmakeargs+=( -DCMAKE_REQUIRE_FIND_PACKAGE_GTest=ON )
	cmake_src_configure
}

src_test() {
	# Bug: https://bugs.gentoo.org/984527
	if [[ -c /dev/kfd ]]; then
		check_amdgpu
	else
		ewarn "/dev/kfd is missing, skipping functional tests"
		local -x GTEST_FILTER="*Unit.*"
	fi

	"${BUILD_DIR}/tests/amd_smi_test/amdsmitst" || die "Test failed"
}

src_install() {
	cmake_src_install
	strip-lto-bytecode

	# Reinstalled below with python_domodule
	rm -r "${D}$(python_get_sitedir)"/amdsmi "${ED}"/usr/bin/amd-smi || die

	python_fix_shebang "${ED}"/usr/libexec/amdsmi_cli
	python_domodule "${ED}"/usr/libexec/amdsmi_cli
	python_domodule "${ED}"/usr/share/amd_smi/amdsmi

	fperms a+x "/usr/lib/${EPYTHON}/site-packages/amdsmi_cli/amdsmi_cli.py"
	dosym -r "/usr/lib/${EPYTHON}/site-packages/amdsmi_cli/amdsmi_cli.py" /usr/bin/amd-smi

	rm -rf "${ED}"/usr/share/amd_smi "${ED}"/usr/libexec/amdsmi_cli || die
}
