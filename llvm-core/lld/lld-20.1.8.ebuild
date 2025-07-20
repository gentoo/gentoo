# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit cmake flag-o-matic llvm.org python-any-r1 toolchain-funcs

DESCRIPTION="The LLVM linker (link editor)"
HOMEPAGE="https://llvm.org/"

LICENSE="Apache-2.0-with-LLVM-exceptions UoI-NCSA"
SLOT="${LLVM_MAJOR}/${LLVM_SOABI}"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc x86 ~arm64-macos ~x64-macos"
IUSE="debug test zstd"
RESTRICT="!test? ( test )"

DEPEND="
	~llvm-core/llvm-${PV}[debug=,zstd=]
	sys-libs/zlib:=
	zstd? ( app-arch/zstd:= )
"
RDEPEND="
	${DEPEND}
	!llvm-core/lld:0
"
BDEPEND="
	llvm-core/llvm:${LLVM_MAJOR}
	test? (
		$(python_gen_any_dep 'dev-python/lit[${PYTHON_USEDEP}]')
	)
"
PDEPEND="
	>=llvm-core/lld-toolchain-symlinks-16-r2:${LLVM_MAJOR}
"

LLVM_COMPONENTS=( lld cmake libunwind/include/mach-o )
LLVM_USE_TARGETS=llvm+eq
llvm.org_set_globals

python_check_deps() {
	python_has_version "dev-python/lit[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_unpack() {
	llvm.org_src_unpack

	# Directory ${WORKDIR}/llvm does not exist with USE="-test",
	# but LLVM_MAIN_SRC_DIR="${WORKDIR}/llvm" is set below,
	# and ${LLVM_MAIN_SRC_DIR}/../libunwind/include is used by build system
	# (lld/MachO/CMakeLists.txt) and is expected to be resolvable
	# to existent directory ${WORKDIR}/libunwind/include.
	mkdir -p "${WORKDIR}/llvm" || die
}

src_configure() {
	# LLVM_ENABLE_ASSERTIONS=NO does not guarantee this for us, #614844
	use debug || local -x CPPFLAGS="${CPPFLAGS} -DNDEBUG"

	use elibc_musl && append-ldflags -Wl,-z,stack-size=2097152

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm/${LLVM_MAJOR}"
		-DLLVM_ROOT="${ESYSROOT}/usr/lib/llvm/${LLVM_MAJOR}"
		-DBUILD_SHARED_LIBS=ON
		-DLLVM_INCLUDE_TESTS=$(usex test)
		-DLLVM_ENABLE_ZLIB=FORCE_ON
		-DLLVM_ENABLE_ZSTD=$(usex zstd FORCE_ON OFF)
		-DLLVM_TARGETS_TO_BUILD="${LLVM_TARGETS// /;}"
	)

	use test && mycmakeargs+=(
		-DLLVM_EXTERNAL_LIT="${EPREFIX}/usr/bin/lit"
		-DLLVM_LIT_ARGS="$(get_lit_flags)"
		-DPython3_EXECUTABLE="${PYTHON}"
	)

	tc-is-cross-compiler &&	mycmakeargs+=(
		-DLLVM_TABLEGEN_EXE="${BROOT}/usr/lib/llvm/${LLVM_MAJOR}/bin/llvm-tblgen"
	)

	cmake_src_configure
}

src_test() {
	local -x LIT_PRESERVES_TMP=1
	cmake_build check-lld
}
