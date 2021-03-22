# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Minimalistic C client library for the Redis database"
HOMEPAGE="https://github.com/redis/hiredis"
SRC_URI="https://github.com/redis/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/1.0.0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ppc ppc64 s390 sparc x86 ~x64-solaris"
IUSE="examples ssl static-libs test"
RESTRICT="!test? ( test )"

DEPEND="
	ssl? ( dev-libs/openssl )
	test? ( dev-db/redis )
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.0-disable-network-tests.patch
)

src_prepare() {
	default

	# use GNU ld syntax on Solaris
	sed -i -e '/DYLIB_MAKE_CMD=.* -G/d' Makefile || die
}

_build() {
	emake \
		AR="$(tc-getAR)" \
		CC="$(tc-getCC)" \
		PREFIX="${EPREFIX}/usr" \
		LIBRARY_PATH="$(get_libdir)" \
		USE_SSL=$(usex ssl 1 0) \
		DEBUG_FLAGS= \
		OPTIMIZATION= \
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
	local REDIS_TEST_CONFIG="
		daemonize yes
		pidfile ${REDIS_PID}
		port ${REDIS_PORT}
		bind 127.0.0.1
		unixsocket //${REDIS_SOCK}
	"

	_build hiredis-test

	"${EPREFIX}"/usr/sbin/redis-server - <<< "${REDIS_TEST_CONFIG}" || die
	./hiredis-test -h 127.0.0.1 -p ${REDIS_PID} -s ${REDIS_SOCK}
	local ret=$?

	kill "$(<"${REDIS_PID}")" || die
	[[ ${ret} != "0" ]] && die "tests failed"
}

src_install() {
	_build PREFIX="${ED}/usr" install

	if ! use static-libs ; then
		find "${ED}" -name '*.a' -delete || die
	fi

	insinto /usr/$(get_libdir)/pkgconfig
	doins ${PN}.pc

	local DOCS=( CHANGELOG.md README.md )
	use examples && DOCS+=( examples )
	einstalldocs
}
