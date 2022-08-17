# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit usr-ldscript verify-sig

DESCRIPTION="Minimalistic netlink library"
HOMEPAGE="https://netfilter.org/projects/libmnl/"
SRC_URI="https://www.netfilter.org/projects/${PN}/files/${P}.tar.bz2
	verify-sig? ( https://www.netfilter.org/projects/${PN}/files/${P}.tar.bz2.sig )"

LICENSE="LGPL-2.1"
SLOT="0/0.2.0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux"
IUSE="examples static-libs"
VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/netfilter.org.asc

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-netfilter )"

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default

	gen_usr_ldscript -a mnl

	find "${D}" -name '*.la' -delete || die

	if use examples; then
		find examples/ -name 'Makefile*' -delete || die
		dodoc -r examples/
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
