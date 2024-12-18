# Copyright 2019-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=18
inherit cmake llvm

MY_COMMIT="0de81efb64acc82c08c5eee4a7108ddcb1b00d86"

DESCRIPTION="Clang-based FFI wrapper generator for Common Lisp"
HOMEPAGE="https://github.com/rpav/c2ffi"
SRC_URI="https://github.com/rpav/c2ffi/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/c2ffi-${MY_COMMIT}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="llvm-core/clang:${LLVM_MAX_SLOT}
	llvm-core/llvm:${LLVM_MAX_SLOT}"
RDEPEND="${DEPEND}"
