# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
CMAKE_MIN_VERSION=3.4.3
PYTHON_COMPAT=( python2_7 )

inherit cmake-utils git-r3 python-single-r1 toolchain-funcs

DESCRIPTION="The LLVM debugger"
HOMEPAGE="http://llvm.org/"
SRC_URI=""
EGIT_REPO_URI="http://llvm.org/git/lldb.git
	https://github.com/llvm-mirror/lldb.git"

LICENSE="UoI-NCSA"
SLOT="0"
KEYWORDS=""
IUSE="libedit ncurses python"

RDEPEND="
	libedit? ( dev-libs/libedit:0= )
	ncurses? ( >=sys-libs/ncurses-5.9-r3:0= )
	python? ( dev-python/six[${PYTHON_USEDEP}]
		${PYTHON_DEPS} )
	~sys-devel/clang-${PV}[xml]
	~sys-devel/llvm-${PV}
	!<sys-devel/llvm-4.0"
DEPEND="${RDEPEND}
	python? ( dev-lang/swig )
	${PYTHON_DEPS}"

REQUIRED_USE=${PYTHON_REQUIRED_USE}

# TODO: --start-group --end-group magic breaks linking against shared clang

src_configure() {
	local libdir=$(get_libdir)
	local mycmakeargs=(
		# used to find cmake modules
		-DLLVM_LIBDIR_SUFFIX="${libdir#lib}"

		-DLLDB_DISABLE_CURSES=$(usex !ncurses)
		-DLLDB_DISABLE_LIBEDIT=$(usex !libedit)
		-DLLDB_DISABLE_PYTHON=$(usex !python)

		# TODO: fix upstream to detect this properly
		-DHAVE_LIBDL=ON
		-DHAVE_LIBPTHREAD=ON
		-DHAVE_TERMINFO=ON # FIXME
	)

	cmake-utils_src_configure
}
