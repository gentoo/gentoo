# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/ipcad/ipcad-3.7.3.ebuild,v 1.7 2014/07/12 17:45:38 jer Exp $

EAPI=5
inherit autotools eutils

DESCRIPTION="IP Cisco Accounting Daemon"
HOMEPAGE="http://sourceforge.net/projects/ipcad/ http://lionet.info/ipcad/"
SRC_URI="mirror://sourceforge/ipcad/${P}.tar.gz"

LICENSE="BSD-2 GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"

RDEPEND="
	net-libs/libpcap
	net-firewall/iptables
"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-3.7-linux-2.6.27.patch \
		"${FILESDIR}"/${PN}-3.7-linux-2.6.35.patch \
		"${FILESDIR}"/${P}-signal_h.patch

	sed -i \
		-e "s|^chroot = /adm/tmp;|chroot = /var/ipcad;|" \
		-e "s|^interface|#&|" \
		-e "s|^aggregate|#&|" \
		-e "s|^pidfile = ipcad.pid;|pidfile = /run/ipcad.pid;|" \
		ipcad.conf.default || die

	eautoreconf
}

src_install() {
	dodoc AUTHORS ChangeLog README BUGS FAQ ipcad.conf.simple ipcad.conf.default

	dosbin ipcad

	insinto /etc
	insopts -m0600
	newins ipcad.conf.default ipcad.conf

	keepdir /var/ipcad/run

	doman ipcad.8 ipcad.conf.5

	newinitd "${FILESDIR}"/ipcad.init ipcad
	newconfd "${FILESDIR}"/ipcad.conf.d ipcad
}
