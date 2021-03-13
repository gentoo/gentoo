# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

MY_PN="swift-corelibs-${PN}"
MY_PV="swift-${PV}-RELEASE"

DESCRIPTION="A library for concurrent code execution on multicore hardware"
HOMEPAGE="https://github.com/apple/swift-corelibs-libdispatch"
SRC_URI="https://github.com/apple/${MY_PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="
	sys-devel/clang
	sys-devel/llvm
"

S="${WORKDIR}/${MY_PN}-${MY_PV}"

src_configure () {
	if ! tc-is-clang ; then
		have_switched_compiler=yes
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
