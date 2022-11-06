# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic cmake toolchain-funcs

MY_PN="swift-corelibs-${PN}"
MY_PV="swift-${PV}-RELEASE"

DESCRIPTION="A library for concurrent code execution on multicore hardware"
HOMEPAGE="https://github.com/apple/swift-corelibs-libdispatch"
SRC_URI="https://github.com/apple/${MY_PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc64 ~riscv x86"

DEPEND="
	!gnustep-base/libobjc2
	!sys-libs/blocksruntime
"
RDEPEND="${DEPEND}"
BDEPEND="
	sys-devel/clang
	sys-devel/llvm
	virtual/pkgconfig
"

S="${WORKDIR}/${MY_PN}-${MY_PV}"

PATCHES=(
	"${FILESDIR}/remove-Werror.patch"
	"${FILESDIR}/libdispatch-5.3.3-musl.patch"
)

src_configure () {
	if ! tc-is-clang ; then
		AR=llvm-ar
		CC=${CHOST}-clang
		CXX=${CHOST}-clang++
		NM=llvm-nm
		RANLIB=llvm-ranlib

		strip-unsupported-flags
	fi

	export HOST_CC="$(tc-getBUILD_CC)"
	export HOST_CXX="$(tc-getBUILD_CXX)"
	tc-export CC CXX LD AR NM OBJDUMP RANLIB PKG_CONFIG

	cmake_src_configure
}
