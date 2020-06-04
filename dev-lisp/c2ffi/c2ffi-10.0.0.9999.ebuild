# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3 llvm

DESCRIPTION="Clang-based FFI wrapper generator for Common Lisp"
HOMEPAGE="https://github.com/rpav/c2ffi"
EGIT_REPO_URI="https://github.com/rpav/c2ffi.git"
EGIT_BRANCH="llvm-10.0.0"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

DEPEND="sys-devel/clang:10=
	sys-devel/llvm:10=
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-10.0.0.20200527-add-target-link-directories.patch )
