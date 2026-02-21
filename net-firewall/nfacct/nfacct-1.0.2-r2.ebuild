# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/netfilter.org.asc
inherit linux-info verify-sig

DESCRIPTION="Command line tool to create/retrieve/delete accounting objects in NetFilter"
HOMEPAGE="https://www.netfilter.org/projects/nfacct/"
SRC_URI="
	https://www.netfilter.org/projects/${PN}/files/${P}.tar.bz2
	verify-sig? ( https://www.netfilter.org/projects/${PN}/files/${P}.tar.bz2.sig )
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv x86"

RDEPEND="
	net-libs/libmnl:=
	>=net-libs/libnetfilter_acct-1.0.3
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	verify-sig? ( sec-keys/openpgp-keys-netfilter )
"

CONFIG_CHECK="~NETFILTER_NETLINK_ACCT"

src_install() {
	default

	keepdir /var/lib/nfacct
	newinitd "${FILESDIR}"/${PN}.initd nfacct
	newconfd "${FILESDIR}"/${PN}.confd nfacct
}
