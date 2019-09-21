# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils git-r3

DESCRIPTION="Clang-based FFI wrapper generator for Common Lisp"
HOMEPAGE="https://github.com/rpav/c2ffi"
EGIT_REPO_URI="https://github.com/rpav/c2ffi.git"
EGIT_BRANCH="llvm-8.0.0"

LICENSE="LGPL-2.1"
SLOT="8"
IUSE=""

DEPEND="sys-devel/clang:8
	sys-devel/llvm:8
"
RDEPEND="${DEPEND}"
