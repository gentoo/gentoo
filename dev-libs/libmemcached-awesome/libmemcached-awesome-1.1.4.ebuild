# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake dot-a

DESCRIPTION="a C/C++ memcached client library"
HOMEPAGE="https://awesomized.github.io/libmemcached/ https://github.com/awesomized/libmemcached"
SRC_URI="https://github.com/awesomized/libmemcached/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/libmemcached-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~ppc ~ppc64 ~riscv ~s390 x86"
IUSE="+libevent sasl test"
RESTRICT="!test? ( test )"

RDEPEND="!app-forensics/memdump
	!dev-libs/libmemcached
	libevent? ( dev-libs/libevent:= )
	sasl? ( dev-libs/cyrus-sasl:2 )"
DEPEND="${RDEPEND}
	test? ( net-misc/memcached )"
BDEPEND="app-alternatives/yacc
	app-alternatives/lex
	virtual/pkgconfig"

src_configure() {
	lto-guarantee-fat
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

src_install() {
	cmake_src_install
	strip-lto-bytecode
}
