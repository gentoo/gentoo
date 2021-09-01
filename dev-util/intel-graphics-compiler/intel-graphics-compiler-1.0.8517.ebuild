# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_BUILD_TYPE="Release"
LLVM_MAX_SLOT="10"
MY_PN="igc"
MY_P="${MY_PN}-${PV}"
PYTHON_COMPAT=( python3_{8..10} )

inherit cmake flag-o-matic llvm python-any-r1

DESCRIPTION="LLVM-based OpenCL compiler for OpenCL targetting Intel Gen graphics hardware"
HOMEPAGE="https://github.com/intel/intel-graphics-compiler"
SRC_URI="https://github.com/intel/${PN}/archive/${MY_P}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

DEPEND="
	dev-libs/opencl-clang:${LLVM_MAX_SLOT}=
	sys-devel/llvm:${LLVM_MAX_SLOT}=
"

RDEPEND="${DEPEND}"

BDEPEND="
	${PYTHON_DEPS}
	>=sys-devel/lld-${LLVM_MAX_SLOT}
"

PATCHES=(
	"${FILESDIR}/${PN}-1.0.9-no_Werror.patch"
	"${FILESDIR}/${PN}-1.0.8173-opencl-clang_version.patch"
	"${FILESDIR}/${PN}-1.0.8173-fix-missing-limits.patch"
	"${FILESDIR}/${PN}-1.0.8365-disable-git.patch"
	"${FILESDIR}/${PN}-1.0.8365-cmake-project.patch"
	"${FILESDIR}/${PN}-1.0.8365-cmake-minimum-version.patch"
)

pkg_setup() {
	llvm_pkg_setup
	python-any-r1_pkg_setup
}

src_configure() {
	# Since late March 2020 cmake.eclass does not set -DNDEBUG any more,
	# and the way IGC uses this definition causes problems for some users.
	# See bug #718824 for more information.
	! use debug && append-cppflags -DNDEBUG

	local mycmakeargs=(
		# Those options are ensuring, that we are using
		# the system LLVM with the correct slot.
		-DCCLANG_SONAME_VERSION="${LLVM_MAX_SLOT}"
		-DCMAKE_LIBRARY_PATH="$(get_llvm_prefix ${LLVM_MAX_SLOT})/$(get_libdir)"
		-DIGC_OPTION__ARCHITECTURE_TARGET="Linux64"
		-DIGC_OPTION__CLANG_MODE="Prebuilds"
		-DIGC_OPTION__LLD_MODE="Prebuilds"
		-DIGC_OPTION__LLDELF_H_DIR="${EPREFIX}/usr/include/lld/Common"
		-DIGC_OPTION__LLVM_MODE="Prebuilds"
		-DIGC_OPTION__LLVM_PREFERRED_VERSION="${LLVM_MAX_SLOT}"

		# VectorCompiler needs work, as at the moment upstream
		# only supports building vc-intrinsics in place.
		-DIGC_BUILD__VC_ENABLED="NO"

		# This will suspress some CMake warnings,
		# which cannot be fixed at the moment.
		-Wno-dev
	)

	cmake_src_configure
}
