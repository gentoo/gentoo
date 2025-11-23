# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools edo toolchain-funcs verify-sig

MY_PN="knot"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Redis module for Knot DNS"
HOMEPAGE="https://www.knot-dns.cz/ https://gitlab.nic.cz/knot/knot-dns"
SRC_URI="
	https://knot-dns.nic.cz/release/${MY_P}.tar.xz
	verify-sig? ( https://knot-dns.nic.cz/release/${MY_P}.tar.xz.asc )
"
S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"

# no test, it requires a Redis instance and RLTest (not packaged)
BDEPEND="
	dev-build/libtool
	verify-sig? ( sec-keys/openpgp-keys-knot )
"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/${MY_PN}.asc

PATCHES=(
	# PR merged https://gitlab.nic.cz/knot/knot-dns/-/merge_requests/1808.patch
	"${FILESDIR}"/${PN}-3.5.0-full_redis_opt.patch
	# https://gitlab.nic.cz/knot/knot-dns/-/merge_requests/1809.patch
	"${FILESDIR}"/${PN}-3.5.0-opt_gnutls.patch
)

# Used to check cpuset_t in sched.h with NetBSD.
# False positive because linux have sched.h too but with cpu_set_t
QA_CONFIG_IMPL_DECL_SKIP=( cpuset_create cpuset_destroy )

# because configure.ac is patched
src_prepare() {
	default
	eautoconf
}

src_configure() {
	econf --disable-daemon --disable-modules --disable-utilities --disable-xdp --enable-redis=module
}

src_compile() {
	pushd src/redis || die

	# mimic src/redis/Makefile.am
	edo ${LIBTOOL:=libtool} --tag=CC --mode=compile $(tc-getCC) \
		${CFLAGS} -fvisibility=hidden \
		-I../../src -include ../../src/config.h \
		-c -o knot_la-knot.lo knot.c

	edo ${LIBTOOL:=libtool} --tag=CC --mode=link $(tc-getCC) \
		-module -shared -avoid-version \
		${LDFLAGS} \
		-o knot.la \
		-rpath "${EPREFIX}"/usr/$(get_libdir)/knot/redis \
		knot_la-knot.lo

	popd || die
}

src_install() {
	exeinto /usr/$(get_libdir)/knot/redis
	doexe src/redis/.libs/knot.so
}
