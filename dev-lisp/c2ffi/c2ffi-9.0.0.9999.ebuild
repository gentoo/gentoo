# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3 llvm

DESCRIPTION="Clang-based FFI wrapper generator for Common Lisp"
HOMEPAGE="https://github.com/rpav/c2ffi"
EGIT_REPO_URI="https://github.com/rpav/c2ffi.git"
EGIT_BRANCH="llvm-9.0.0"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

DEPEND="sys-devel/clang:9=
	sys-devel/llvm:9=
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-9.0.0.20191017-fix-lib-location.patch )
