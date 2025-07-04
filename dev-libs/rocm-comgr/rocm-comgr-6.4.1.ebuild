# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( 20 )

inherit cmake llvm-r1 prefix

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
	"${FILESDIR}/${PN}-5.1.3-rocm-path.patch"
	"${FILESDIR}/0001-Find-CLANG_RESOURCE_DIR-using-clang-print-resource-d.patch"
	"${FILESDIR}/${PN}-6.4.1-extend-isa-compatibility-check.patch"
	"${FILESDIR}/${PN}-6.4.1-fix-comgr-default-flags.patch"
	"${FILESDIR}/${PN}-6.1.0-dont-add-nogpulib.patch"
	"${FILESDIR}/${PN}-6.4.1-bypass-device-libs-copy.patch"
	"${FILESDIR}/${PN}-6.4.1-llvm-20-compat.patch"
)

RDEPEND="
	dev-libs/rocm-device-libs:${SLOT}
	llvm-core/clang-runtime:=
	$(llvm_gen_dep '
		llvm-core/clang:${LLVM_SLOT}=
		llvm-core/lld:${LLVM_SLOT}=
	')
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
	sed '/sys::path::append(HIPPath/s,"hip","",' -i src/comgr-env.cpp || die
	sed "/return LLVMPath;/s,LLVMPath,llvm::SmallString<128>(\"$(get_llvm_prefix)\")," -i src/comgr-env.cpp || die
	eapply $(prefixify_ro "${FILESDIR}"/${PN}-6.3.2-rocm_path.patch)

	cmake_src_prepare

	# Replace @CLANG_RESOURCE_DIR@ in patches
	local CLANG_RESOURCE_DIR="$("$(get_llvm_prefix)"/bin/clang -print-resource-dir)"
	sed "s,@CLANG_RESOURCE_DIR@,\"${CLANG_RESOURCE_DIR}\"," -i src/comgr-compiler.cpp || die
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
	local CMAKE_SKIP_TESTS=(
		comgr_nested_kernel_test # See https://github.com/ROCm/llvm-project/issues/35
	)
	cmake_src_test
}
