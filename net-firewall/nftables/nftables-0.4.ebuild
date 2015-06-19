# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-firewall/nftables/nftables-0.4.ebuild,v 1.3 2014/12/20 14:51:14 mrueg Exp $

EAPI=5

inherit autotools linux-info

DESCRIPTION="Linux kernel (3.13+) firewall, NAT and packet mangling tools"
HOMEPAGE="http://netfilter.org/projects/nftables/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="debug +readline"
SRC_URI="http://netfilter.org/projects/${PN}/files/${P}.tar.bz2"

RDEPEND="net-libs/libmnl
	>=net-libs/libnftnl-1.0.2
	dev-libs/gmp
	readline? ( sys-libs/readline )"
DEPEND="${RDEPEND}
	>=app-text/docbook2X-0.8.8-r4
	sys-devel/bison
	sys-devel/flex"

pkg_setup() {
	if kernel_is ge 3 13; then
		CONFIG_CHECK="~NF_TABLES"
		linux-info_pkg_setup
	else
		eerror "This package requires kernel version 3.13 or newer to work properly."
	fi
}

src_prepare() {
	epatch_user
	eautoreconf
}

src_configure() {
	econf \
		--sbindir="${EPREFIX}"/sbin \
		$(use_enable debug) \
		$(use_with readline cli)
}

src_install() {
	default

	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	newinitd "${FILESDIR}"/${PN}.init ${PN}
	keepdir /var/lib/nftables
}
