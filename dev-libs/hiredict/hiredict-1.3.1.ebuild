# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Minimalistic C client library for the Redict database"
HOMEPAGE="https://codeberg.org/redict/hiredict"
SRC_URI="https://codeberg.org/redict/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

S=${WORKDIR}/${PN}

LICENSE="BSD LGPL-3"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"
IUSE="shim ssl static-libs test"
RESTRICT="!test? ( test )"

DEPEND="
	ssl? ( dev-libs/openssl:= )
	shim? ( !dev-libs/hiredis )
"
RDEPEND="${DEPEND}"
BDEPEND="
	test? (
		dev-db/redict
		dev-libs/libevent
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.3.1-disable-network-tests.patch
)

_build() {
	tc-export AR CC
	local myconf=(
		AR="${AR}"
		CC="${CC}"
		CFLAGS="${CFLAGS}"
		LDFLAGS="${LDFLAGS}"
		DESTDIR="${ED}"
		PREFIX="/usr"
		LIBRARY_PATH="$(get_libdir)"
		USE_SSL=$(usex ssl 1 0)
		TEST_ASYNC=$(usex test 1 0)
		DEBUG_FLAGS=
		OPTIMIZATION=
		USE_WERROR=0
	)
	emake "${myconf[@]}" "$@"
}

src_compile() {
	# The static lib re-uses the same objects as the shared lib, so
	# overhead is low w/creating it all the time.  It's also needed
	# by the tests.
	_build dynamic static hiredict{,_ssl}.pc
}

src_test() {
	# Compare with https://codeberg.org/redict/hiredict/src/tag/1.3.1/Makefile#L37
	local REDICT_PID="${T}"/hiredict.pid
	local REDICT_SOCK="${T}"/hiredict.sock
	local REDICT_PORT=56379
	local REDICT_TEST_CONFIG="
		daemonize yes
		pidfile ${REDICT_PID}
		port ${REDICT_PORT}
		bind 127.0.0.1
		unixsocket //${REDICT_SOCK}
	"

	_build hiredict-test

	"${EPREFIX}"/usr/bin/redict-server - <<< "${REDICT_TEST_CONFIG}" || die
	./hiredict-test -h 127.0.0.1 -p ${REDICT_PORT} -s ${REDICT_SOCK}
	local ret=$?

	kill "$(<"${REDICT_PID}")" || die
	[[ ${ret} != "0" ]] && die "tests failed"
}

src_install() {
	_build install

	if ! use static-libs ; then
		find "${ED}" -name '*.a' -delete || die
	fi

	if ! use shim; then
		find "${ED}" -type d -name 'hiredis' -exec rm -r {} + || die
		find "${ED}" -name 'hiredis*.pc' -delete || die
	fi
}
