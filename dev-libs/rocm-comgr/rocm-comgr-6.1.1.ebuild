# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( 18 )

inherit cmake llvm-r1 prefix

MY_P=llvm-project-rocm-${PV}
components=( "amd/comgr" )

DESCRIPTION="Radeon Open Compute Code Object Manager"
HOMEPAGE="https://github.com/ROCm/ROCm-CompilerSupport"
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
	"${FILESDIR}/${PN}-5.7.1-correct-license-install-dir.patch"
	"${FILESDIR}/${PN}-6.0.0-extend-isa-compatibility-check.patch"
	"${FILESDIR}/${PN}-6.1.0-llvm-18-compat.patch"
	"${FILESDIR}/${PN}-6.1.0-enforce-oop-compiler.patch"
	"${FILESDIR}/${PN}-6.1.0-fix-comgr-default-flags.patch"
	"${FILESDIR}/${PN}-6.1.0-dont-add-nogpulib.patch"
)

RDEPEND=">=dev-libs/rocm-device-libs-${PV}
	sys-devel/clang-runtime:=
	$(llvm_gen_dep '
		sys-devel/clang:${LLVM_SLOT}=
		sys-devel/lld:${LLVM_SLOT}=
	')
	dev-util/hipcc:${SLOT}
"
DEPEND="${RDEPEND}"

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
	eapply $(prefixify_ro "${FILESDIR}"/${PN}-5.0-rocm_path.patch)

	cmake_src_prepare

	# Replace @CLANG_RESOURCE_DIR@ in patches
	local CLANG_RESOURCE_DIR="$("$(get_llvm_prefix)"/bin/clang -print-resource-dir)"
	sed "s,@CLANG_RESOURCE_DIR@,\"${CLANG_RESOURCE_DIR}\"," -i src/comgr-compiler.cpp || die
}

src_configure() {
	local mycmakeargs=(
		-DLLVM_DIR="$(get_llvm_prefix)"
		-DCMAKE_STRIP=""  # disable stripping defined at lib/comgr/CMakeLists.txt:58
		-DBUILD_TESTING=$(usex test ON OFF)
	)
	cmake_src_configure
}

src_test() {
	local CMAKE_SKIP_TESTS=(
		comgr_nested_kernel_test # See https://github.com/ROCm/llvm-project/issues/35
	)
	cmake_src_test
}
