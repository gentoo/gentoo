# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="High-performance asynchronous messaging library"
HOMEPAGE="https://zeromq.org/"
SRC_URI="https://github.com/zeromq/libzmq/releases/download/v${PV}/${P}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0/5"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~arm64-macos ~x64-macos"
IUSE="debug doc drafts +libbsd +sodium static-libs test unwind"
RESTRICT="!test? ( test )"

RDEPEND="
	!elibc_Darwin? ( unwind? ( sys-libs/libunwind ) )
	libbsd? ( dev-libs/libbsd:= )
	sodium? ( dev-libs/libsodium:= )
"
DEPEND="
	${RDEPEND}
	!elibc_Darwin? ( sys-apps/util-linux )
"
BDEPEND="
	virtual/pkgconfig
	doc? (
		app-text/asciidoc
		app-text/xmlto
	)
"

DOCS=()

PATCHES=(
	"${FILESDIR}"/${PN}-4.3.5-c99.patch
	"${FILESDIR}"/${PN}-4.3.5-cmake-doc.patch
	"${FILESDIR}"/${PN}-4.3.5-cmake-test.patch
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED=ON
		-DBUILD_STATIC=$(usex static-libs)
		-DENABLE_DRAFTS=$(usex drafts)
		-DENABLE_INTRINSICS=$(usex debug)
		-DWITH_DOCS=$(usex doc)
		-DWITH_PERF_TOOL=$(usex debug)
		-DWITH_LIBBSD=$(usex libbsd)
		-DWITH_LIBSODIUM=$(usex sodium)
	)

	cmake_src_configure
}
