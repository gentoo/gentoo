# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_MAX_SLOT=14
inherit cmake llvm

MY_COMMIT="25fcec13381f495460f4a4eafdd1b939c799df4a"

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
