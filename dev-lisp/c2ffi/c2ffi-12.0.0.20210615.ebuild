# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake llvm

MY_COMMIT="3a92064409d258e1688727266c3f023a502e8866"

DESCRIPTION="Clang-based FFI wrapper generator for Common Lisp"
HOMEPAGE="https://github.com/rpav/c2ffi"
SRC_URI="https://github.com/rpav/c2ffi/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="sys-devel/clang:12=
	sys-devel/llvm:12=
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/c2ffi-${MY_COMMIT}"
