# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils git-r3 llvm

DESCRIPTION="A Fortran compiler targeting LLVM"
HOMEPAGE="https://github.com/flang-compiler/flang"
EGIT_REPO_URI="git://github.com/flang-compiler/flang.git
		https://github.com/flang-compiler/flang.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="sys-devel/clang[flang(-)]"
RDEPEND="${DEPEND}"

LLVM_MAX_SLOT=4

src_prepare() {
	default

	#https://github.com/flang-compiler/flang/pull/88
	#https://github.com/flang-compiler/flang/pull/85
	sed -e '/set(LLVM_CMAKE_PATH/s/)$/ CACHE PATH "Allow of override"&/' \
	    -e 's/-Werror//' -i CMakeLists.txt
}

src_configure() {
	local -x CC=$(type -p ${CHOST}-clang)
	local -x CXX=$(type -p ${CHOST}-clang++)
	local -x FC=$(type -p flang)

	local mycmakeargs=(
		-DTARGET_ARCHITECTURE=$(uname -m) #https://github.com/flang-compiler/flang/pull/83
		-DTARGET_OS=$(uname -s) #https://github.com/flang-compiler/flang/pull/86
		-DLLVM_CMAKE_PATH="$(get_llvm_prefix)/$(get_libdir)/cmake/llvm"
	)

	cmake-utils_src_configure
}
