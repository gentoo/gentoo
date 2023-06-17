# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=15
inherit cmake llvm

MY_COMMIT="3078cb57ccfa43736aa93720a72f1074034cb37d"

DESCRIPTION="Clang-based FFI wrapper generator for Common Lisp"
HOMEPAGE="https://github.com/rpav/c2ffi"
SRC_URI="https://github.com/rpav/c2ffi/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/c2ffi-${MY_COMMIT}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="sys-devel/clang:${LLVM_MAX_SLOT}
	sys-devel/llvm:${LLVM_MAX_SLOT}"
RDEPEND="${DEPEND}"
