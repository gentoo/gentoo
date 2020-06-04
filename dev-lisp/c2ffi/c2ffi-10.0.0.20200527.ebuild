# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake llvm

MY_COMMIT="a2d1f667b707fb413fc8ab2413446f15cb23de51"

DESCRIPTION="Clang-based FFI wrapper generator for Common Lisp"
HOMEPAGE="https://github.com/rpav/c2ffi"
SRC_URI="https://github.com/rpav/c2ffi/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="sys-devel/clang:10=
	sys-devel/llvm:10=
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/c2ffi-${MY_COMMIT}"

PATCHES=( "${FILESDIR}"/${PN}-10.0.0.20200527-add-target-link-directories.patch )
