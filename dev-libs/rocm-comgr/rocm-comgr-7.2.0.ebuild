# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( 22 )

inherit cmake llvm-r2

MY_P=llvm-project-rocm-${PV}
components=( "amd/comgr" )

DESCRIPTION="Radeon Open Compute Code Object Manager"
HOMEPAGE="https://github.com/ROCm/llvm-project/tree/amd-staging/amd/comgr"
SRC_URI="https://github.com/ROCm/llvm-project/archive/rocm-${PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}/${components[0]}"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"

IUSE="test"
RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}/${PN}-6.4.1-extend-isa-compatibility-check.patch"
	"${FILESDIR}/${PN}-6.1.0-dont-add-nogpulib.patch"
	"${FILESDIR}/${PN}-7.2.0-llvm-22-compat.patch"
)

RDEPEND="
	dev-libs/rocm-device-libs:${SLOT}
	llvm-runtimes/clang-runtime:=
	$(llvm_gen_dep "
		llvm-core/clang:\${LLVM_SLOT}=
		llvm-core/lld:\${LLVM_SLOT}=
		llvm-core/llvm:\${LLVM_SLOT}=
	")
	dev-util/hipcc:${SLOT}
"
DEPEND="${RDEPEND}"

# Circular dependency: to build tests, hip compiler must be functional
BDEPEND="test? ( dev-util/hip:${SLOT} )"

CMAKE_BUILD_TYPE=Release

src_unpack() {
	if [[ ${PV} == *9999 ]] ; then
		git-r3_fetch
		git-r3_checkout '' . '' "${components[@]}"
	else
		archive="${MY_P}.tar.gz"
		ebegin "Unpacking from ${archive}"
		tar -x -z -o \
			-f "${DISTDIR}/${archive}" \
			"${components[@]/#/${MY_P}/}" || die
		eend ${?}
	fi
}

src_prepare() {
	sed -e "s:\${CLANG_CMAKE_DIR}/../../../\*:${EPREFIX}/usr/lib/clang/${LLVM_SLOT}/include:" \
		-i cmake/opencl_header.cmake || die

	# Backports for llvm-22 from amd-staging:
	# https://github.com/ROCm/llvm-project/commit/ebcaa3d9226921c8761a5291526291e54611e4a4
	# https://github.com/ROCm/llvm-project/commit/ccb14ba83fd6bdc01423f71944b4676f740b97cc
	sed -e "s:Driver/Options.h:Options/Options.h:" \
		-e "s/clang::driver::options/clang::options/" \
		-e "s/Driver::GetResourcesPath/GetResourcesPath/" \
		-i src/comgr-compiler.cpp || die

	cmake_src_prepare
}

src_configure() {
	llvm_prepend_path "${LLVM_SLOT}"

	local mycmakeargs=(
		-DCMAKE_STRIP=""  # disable stripping defined at lib/comgr/CMakeLists.txt:58
		-DBUILD_TESTING=$(usex test ON OFF)
		-DCOMGR_DISABLE_SPIRV=ON  # requires ROCm/SPIRV-LLVM-Translator (fork of dev-util/spirv-llvm-translator)
	)
	# Prevent CMake from finding systemwide hip, which breaks tests
	use test && mycmakeargs+=( -DCMAKE_DISABLE_FIND_PACKAGE_hip=ON )
	cmake_src_configure
}

src_test() {
	cmake_src_test
}
