# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="a C/C++ memcached client library"
HOMEPAGE="https://github.com/awesomized/libmemcached"
SRC_URI="https://github.com/awesomized/libmemcached/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/libmemcached-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="+libevent sasl test"
RESTRICT="!test? ( test )"

RDEPEND="!dev-libs/libmemcached
	libevent? ( dev-libs/libevent:= )
	sasl? ( dev-libs/cyrus-sasl:2 )"
DEPEND="${RDEPEND}
	test? ( net-misc/memcached )"
BDEPEND="sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
		-DENABLE_DTRACE=OFF
		-DENABLE_SASL=$(usex sasl)
	)

	cmake_src_configure
}

src_test() {
	local myctestargs=(
		# memcached_regression_lp583031: needs network, bug #845123
		# bin/memaslap: tries to use Portage HOMEDIR, bug #845123
		-E "(memcached_regression_lp583031|bin/memaslap|memcached_udp)"
	)

	cmake_src_test
}
