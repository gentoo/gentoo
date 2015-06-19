# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/hiredis/hiredis-0.13.1.ebuild,v 1.1 2015/06/15 06:58:52 mgorny Exp $

EAPI=5

inherit eutils multilib

DESCRIPTION="Minimalistic C client library for the Redis database"
HOMEPAGE="http://github.com/redis/hiredis"
SRC_URI="http://github.com/redis/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc64 ~x86 ~x86-fbsd ~x64-solaris"
IUSE="examples static-libs test"

DEPEND="test? ( dev-db/redis )"

src_prepare() {
	epatch "${FILESDIR}/${P}-disable-network-tests.patch"

	# use GNU ld syntax on Solaris
	sed -i -e '/DYLIB_MAKE_CMD=.* -G/d' Makefile || die
}

_build() {
	emake \
		AR="$(tc-getAR)" \
		CC="$(tc-getCC)" \
		PREFIX="${EPREFIX%/}/usr" \
		LIBRARY_PATH="$(get_libdir)" \
		ARCH= \
		DEBUG= \
		OPTIMIZATION="${CPPFLAGS}" \
		"$@"
}

src_compile() {
	# The static lib re-uses the same objects as the shared lib, so
	# overhead is low w/creating it all the time.  It's also needed
	# by the tests.
	_build dynamic static hiredis.pc
}

src_test() {
	local REDIS_PID="${T}"/hiredis.pid
	local REDIS_SOCK="${T}"/hiredis.sock
	local REDIS_PORT=56379
	local REDIS_TEST_CONFIG="daemonize yes
		pidfile ${REDIS_PID}
		port ${REDIS_PORT}
		bind 127.0.0.1
		unixsocket //${REDIS_SOCK}"

	_build hiredis-test

	/usr/sbin/redis-server - <<< "${REDIS_TEST_CONFIG}" || die
	./hiredis-test -h 127.0.0.1 -p ${REDIS_PID} -s ${REDIS_SOCK}
	local ret=$?

	kill "$(<"${REDIS_PID}")" || die
	[ ${ret} != "0" ] && die "tests failed"
}

src_install() {
	_build PREFIX="${ED%/}/usr" install
	if use static-libs; then
		rm "${ED%/}/usr/$(get_libdir)/libhiredis.a" || die
	fi
	use examples && dodoc -r examples

	insinto /usr/$(get_libdir)/pkgconfig
	doins ${PN}.pc

	dodoc CHANGELOG.md README.md
}
