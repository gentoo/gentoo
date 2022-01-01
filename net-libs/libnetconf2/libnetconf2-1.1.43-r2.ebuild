# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="C library for building NETCONF servers and clients"
HOMEPAGE="https://github.com/CESNET/libnetconf2"
SRC_URI="https://github.com/CESNET/libnetconf2/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/openssl:0=
	>=net-libs/libyang-1.0.225:=
	<net-libs/libyang-2.0.0:=
	net-libs/libssh:0=[server]
	virtual/libcrypt:="
DEPEND="${RDEPEND}
	test? ( dev-util/cmocka )"
BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen[dot] )"

src_configure() {
	local mycmakeargs=(
		-DENABLE_BUILD_TESTS=$(usex test)
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	use doc && cmake_src_compile doc
}

src_install() {
	cmake_src_install

	use doc && dodoc -r doc/.
}
