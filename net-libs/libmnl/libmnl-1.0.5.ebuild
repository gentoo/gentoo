# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/netfilter.org.asc
inherit verify-sig

DESCRIPTION="Minimalistic netlink library"
HOMEPAGE="https://netfilter.org/projects/libmnl/"
SRC_URI="https://www.netfilter.org/projects/${PN}/files/${P}.tar.bz2
	verify-sig? ( https://www.netfilter.org/projects/${PN}/files/${P}.tar.bz2.sig )"

LICENSE="LGPL-2.1"
SLOT="0/0.2.0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux"
IUSE="examples"

DEPEND="elibc_musl? ( sys-libs/queue-standalone )"
BDEPEND="verify-sig? ( sec-keys/openpgp-keys-netfilter )"

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die

	if use examples; then
		find examples/ -name 'Makefile*' -delete || die
		dodoc -r examples/
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
