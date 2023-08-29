# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
inherit cmake crossdev flag-o-matic llvm llvm.org python-any-r1 toolchain-funcs

DESCRIPTION="The LLVM C Library"
HOMEPAGE="https://libc.llvm.org"

LICENSE="Apache-2.0-with-LLVM-exceptions"
SLOT="${LLVM_MAJOR}"
KEYWORDS=""
IUSE="headers-only"

BDEPEND="
	sys-apps/libc-hdrgen:${LLVM_MAJOR}
	${PYTHON_DEPS}
"

# compiler-rt is needed for the SCUDO allocator
LLVM_COMPONENTS=( runtimes libc compiler-rt cmake llvm/cmake )
llvm.org_set_globals

pkg_setup() {
	if target_is_not_host || tc-is-cross-compiler ; then
		CHOST=${CTARGET} strip-unsupported-flags
	fi

	python-any-r1_pkg_setup
}

src_configure() {
	BUILD_DIR=${WORKDIR}/${P}_build

	local mycmakeargs=(
		-DLLVM_LIBC_FULL_BUILD=ON
		# Do not bundle llvm-libc's libc-hdrgen
		-DLIBC_HDRGEN_EXE="${BROOT}/usr/bin/libc-hdrgen"
		-DPython3_EXECUTABLE="${PYTHON}"
	)

	if use headers-only ; then
		mycmakeargs+=(
			-DLLVM_ENABLE_RUNTIMES=libc
		)
	else
		mycmakeargs+=(
			-DLLVM_ENABLE_RUNTIMES="libc;compiler-rt"
			# SCUDO is the allocator for LLVM libc, and it is a pain to
			# keep separate from the main libc library as you would need
			# to pass extra link flags for every compilation. This builds
			# it into the libc.a archive.
			-DLLVM_LIBC_INCLUDE_SCUDO=ON
			-DCOMPILER_RT_BUILD_GWP_ASAN=OFF
			-DCMAKE_TRY_COMPILE_TARGET_TYPE=STATIC_LIBRARY

			# This is only used for targeting libc/ headers in the current llvm-project directory
			# Crossdev has already handled the headers for us
			-DCOMPILER_RT_BUILD_SCUDO_STANDALONE_WITH_LLVM_LIBC=$(is_crosspkg OFF ON)
		)
	fi
	if is_crosspkg ; then
		mycmakeargs+=(
			-DCMAKE_C_COMPILER_WORKS=1
			-DCMAKE_CXX_COMPILER_WORKS=1
			-DCMAKE_INSTALL_PREFIX="/usr/${CTARGET}/usr"
		)
	fi

	cmake_src_configure
}

src_compile() {
	use headers-only && return
	cmake_build libc libc-startup libm
}

src_install() {
	DESTDIR="${D}" cmake_build $(usex headers-only install-libc-headers install-libc)
}
