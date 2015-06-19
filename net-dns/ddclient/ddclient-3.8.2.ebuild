# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/ddclient/ddclient-3.8.2.ebuild,v 1.1 2014/01/30 12:33:29 titanofold Exp $

EAPI="5"
inherit systemd user

DESCRIPTION="Perl updater client for dynamic DNS services"
HOMEPAGE="http://ddclient.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="hardened"

RDEPEND=">=dev-lang/perl-5.1
		 virtual/perl-Digest-SHA
		 dev-perl/IO-Socket-SSL
		 hardened? ( sys-apps/iproute2 )
"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_prepare() {
	# Remove pid setting because we can't leave it user configurable and
	# reliably setup the environment for the init script to stop ${PN}
	ebegin "Removing PID setting from ${PN}.conf"
	sed '/^pid/d' -i "sample-etc_${PN}.conf"
	eend $?
}

src_install() {
	dosbin ${PN}
	dodoc Change* COPYRIGHT README* RELEASENOTE sample*

	newinitd "${FILESDIR}/${PN}.initd-r4" ${PN}
	systemd_dounit "${FILESDIR}"/${PN}.service

	insopts -m 0600 -o ${PN} -g ${PN}
	insinto /etc/${PN}
	newins sample-etc_${PN}.conf ${PN}.conf
	newins sample-etc_${PN}.conf ${PN}.conf.sample
}
