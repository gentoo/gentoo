# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit verify-sig

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
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-knot )"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/${MY_PN}.asc

# Used to check cpuset_t in sched.h with NetBSD.
# False positive because linux have sched.h too but with cpu_set_t
QA_CONFIG_IMPL_DECL_SKIP=( cpuset_create cpuset_destroy )

src_configure() {
	local myeconfargs=(
		--disable-daemon
		--disable-modules
		--disable-utilities
		--disable-xdp
		--enable-redis=module
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	emake -C src/redis
}

src_install() {
	emake DESTDIR="${D}" -C src/redis install

	find "${D}" -name '*.la' -delete || die
}
