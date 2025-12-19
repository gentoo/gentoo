# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic cmake toolchain-funcs

MY_PN="swift-corelibs-${PN}"
MY_PV="swift-${PV}-RELEASE"

DESCRIPTION="Library for concurrent code execution on multicore hardware"
HOMEPAGE="https://github.com/swiftlang/swift-corelibs-libdispatch"
SRC_URI="https://github.com/swiftlang/${MY_PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${MY_PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="test"

RESTRICT="!test? ( test )"

DEPEND="
	!gnustep-base/libobjc2[-libdispatch(-)]
	!sys-libs/blocksruntime
"
RDEPEND="${DEPEND}"
BDEPEND="
	llvm-core/clang
	llvm-core/llvm
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}/remove-Werror.patch"
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

	local mycmakeargs=(
		-D_GNU_SOURCE=ON # fix musl bug #967741
		-DINSTALL_PRIVATE_HEADERS=ON # private headers needed by gnustep-base/libobjc2[libdispatch]
		-DBUILD_TESTING=$(usex test)
	)
	cmake_src_configure
}
