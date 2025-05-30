# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake toolchain-funcs

DESCRIPTION="An open-source C implementation of the RPKI/Router Protocol client"
HOMEPAGE="https://rtrlib.realmv6.org/"
SRC_URI="https://github.com/rtrlib/rtrlib/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="doc ssh test"
RESTRICT="!test? ( test )"

RDEPEND="ssh? ( net-libs/libssh:0= )"
DEPEND="
	${RDEPEND}
	test? ( dev-util/cmocka )
"
BDEPEND="
	doc? ( app-text/doxygen[dot] )
"

PATCHES=(
	"${FILESDIR}"/${P}-no-network-tests.patch
	"${FILESDIR}"/${P}-tests-strict-aliasing.patch
	"${FILESDIR}"/${P}-cmake4.patch
)

src_prepare() {
	# fix path for installing docs
	sed -i -e "s:share/doc/rtrlib:share/doc/${PF}:" CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package doc Doxygen)
		-DRTRLIB_TRANSPORT_SSH=$(usex ssh)
		-DUNIT_TESTING=$(usex test)
	)

	cmake_src_configure
}

src_test() {
	tc-is-lto && CMAKE_SKIP_TESTS+=(
		# These tests use cmocka (so --wrap) which goes wrong
		# with LTO: bug #951662.
		test_packets
		test_packets_static
	)

	cmake_src_test
}

src_install() {
	cmake_src_install
	find "${D}" -name '*.la' -delete || die
}
