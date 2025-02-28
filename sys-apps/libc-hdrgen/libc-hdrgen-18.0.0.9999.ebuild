# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
inherit cmake llvm llvm.org python-any-r1

DESCRIPTION="Generate headers for LLVM libc"
HOMEPAGE="https://libc.llvm.org"

LICENSE="Apache-2.0-with-LLVM-exceptions"
SLOT="${LLVM_MAJOR}"
KEYWORDS=""

BDEPEND="${PYTHON_DEPS}"

LLVM_COMPONENTS=( llvm libc cmake )
llvm.org_set_globals

src_configure() {
	local mycmakeargs=(
		# libc-hdrgen is a part of LLVM libc
		-DLLVM_ENABLE_PROJECTS=libc
		-DLIBC_HDRGEN_ONLY=ON
		-DLLVM_LIBC_FULL_BUILD=ON

		# Building shared libs causes libc-hdrgen to be dynamically
		# linked to some LLVM libraries that may be built by other LLVM
		# ebuilds, keeping track of them is a bit of a pain, so let's
		# just statically link this for now. Especially since there's no
		# CMake target to install libc-hdrgen only.
		-DBUILD_SHARED_LIBS=OFF

		-DLLVM_INCLUDE_BENCHMARKS=OFF
		-DPython3_EXECUTABLE="${PYTHON}"
	)

	cmake_src_configure
}

src_compile() {
	cmake_build libc-hdrgen
}

src_install() {
	# There's no CMake target to only install libc-hdrgen.
	dobin "${BUILD_DIR}"/bin/libc-hdrgen
}
