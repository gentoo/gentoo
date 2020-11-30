# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake llvm

MY_COMMIT="07cda9bd315859d98bb4db83462952bb1bf5ea23"

DESCRIPTION="Clang-based FFI wrapper generator for Common Lisp"
HOMEPAGE="https://github.com/rpav/c2ffi"
SRC_URI="https://github.com/rpav/c2ffi/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="sys-devel/clang:11=
	sys-devel/llvm:11=
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/c2ffi-${MY_COMMIT}"

PATCHES=( "${FILESDIR}"/${PN}-10.0.0.20200527-add-target-link-directories.patch )
