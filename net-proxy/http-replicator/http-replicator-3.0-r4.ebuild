# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-proxy/http-replicator/http-replicator-3.0-r4.ebuild,v 1.6 2015/03/21 20:09:06 jlec Exp $

EAPI=4
PYTHON_DEPEND="2:2.7:2.7" # not 2.6 bug #33907, not 3.0 bug #411083
inherit eutils python systemd

MY_P="${PN}_${PV}"

DESCRIPTION="Proxy cache for Gentoo packages"
HOMEPAGE="http://sourceforge.net/projects/http-replicator"
SRC_URI="mirror://sourceforge/http-replicator/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 hppa ppc ~sparc x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_compile() {
	epatch "${FILESDIR}/http-replicator-3.0-sighup.patch"
	einfo "No compilation necessary"
}

src_install(){
	# Daemon and repcacheman into /usr/bin
	dobin http-replicator
	newexe "${FILESDIR}/http-replicator-3.0-callrepcacheman-0.1" repcacheman
	newexe "${FILESDIR}/http-replicator-3.0-repcacheman-0.44-r2" repcacheman.py

	# init.d scripts
	newinitd "${FILESDIR}/http-replicator-3.0.init" http-replicator
	newconfd "${FILESDIR}/http-replicator-3.0.conf" http-replicator

	systemd_dounit "${FILESDIR}"/http-replicator.service
	systemd_install_serviced "${FILESDIR}"/http-replicator.service.conf

	# not 2.6 bug #33907, not 3.0 bug #411083
	python_convert_shebangs -r 2.7 "${ED}"

	# Docs
	dodoc README debian/changelog

	# Man Page - Not Gentooified yet
	doman http-replicator.1

	insinto /etc/logrotate.d
	newins debian/logrotate http-replicator
}

pkg_postinst() {
	einfo
	einfo "Before starting http-replicator, please follow the next few steps:"
	einfo "- modify /etc/conf.d/http-replicator if required"
	einfo "- run /usr/bin/repcacheman to set up the cache"
	einfo "- add http_proxy=\"http://serveraddress:8080\" to make.conf on"
	einfo "  the server as well as on the client machines"
	einfo "- make sure GENTOO_MIRRORS in /etc/make.conf starts with several"
	einfo "  good http mirrors"
	einfo
	einfo "For more information please refer to the following forum thread:"
	einfo "  http://forums.gentoo.org/viewtopic-t-173226.html"
	einfo
}
