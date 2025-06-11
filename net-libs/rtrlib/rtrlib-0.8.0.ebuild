# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake toolchain-funcs

DESCRIPTION="An open-source C implementation of the RPKI/Router Protocol client"
HOMEPAGE="https://rtrlib.realmv6.org/"
SRC_URI="https://github.com/rtrlib/rtrlib/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="doc ssh test"
RESTRICT="!test? ( test )"

RDEPEND="ssh? ( net-libs/libssh:0= )"
DEPEND="
	${RDEPEND}
	doc? ( app-text/doxygen[dot] )
	test? ( dev-util/cmocka )
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.8.0-no-network-tests.patch
	"${FILESDIR}"/${PN}-0.8.0-tests-strict-aliasing.patch
)

src_prepare() {
	# Fix automagic dependency on doxygen, fix path for installing docs
	if use doc; then
		sed -i -e "s:share/doc/rtrlib:share/doc/${PF}:" CMakeLists.txt || die
	else
		sed -i -e '/find_package(Doxygen)/d' CMakeLists.txt || die
	fi
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
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
