# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit linux-info verify-sig

DESCRIPTION="Library providing interface to extended accounting infrastructure"
HOMEPAGE="https://netfilter.org/projects/libnetfilter_acct/"
SRC_URI="https://www.netfilter.org/projects/${PN}/files/${P}.tar.bz2
	verify-sig? ( https://www.netfilter.org/projects/${PN}/files/${P}.tar.bz2.sig )"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~ia64 ppc ~ppc64 ~riscv x86 ~amd64-linux"
IUSE="examples"
VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/netfilter.org.asc

RDEPEND="
	net-libs/libmnl
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	verify-sig? ( sec-keys/openpgp-keys-netfilter )"

DOCS=( README )

CONFIG_CHECK="~NETFILTER_NETLINK_ACCT"

pkg_setup() {
	kernel_is lt 3 3 && ewarn "This package will work with kernel version 3.3 or higher"
	linux-info_pkg_setup
}

src_configure() {
	econf \
		--libdir="${EPREFIX}"/$(get_libdir)
}

src_install() {
	default

	dodir /usr/$(get_libdir)/pkgconfig/
	mv "${ED}"/{,usr/}$(get_libdir)/pkgconfig/${PN}.pc || die

	if use examples; then
		find examples/ -name "Makefile*" -exec rm -f '{}' + || die 'find failed'
		dodoc -r examples/
		docompress -x /usr/share/doc/${P}/examples
	fi

	find "${ED}" -name '*.la' -delete || die
}
