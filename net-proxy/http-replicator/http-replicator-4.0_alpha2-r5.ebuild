# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit eutils python-r1 systemd

MY_P="${PN}_${PV/_/}"

DESCRIPTION="Proxy cache for Gentoo packages"
HOMEPAGE="https://sourceforge.net/projects/http-replicator"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~sparc ~x86"

S="${WORKDIR}/${MY_P}"

# Tests downloads files as well as breaks, should be turned into local tests.
RESTRICT="test"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-4.0_alpha2-r3-pid.patch
}

src_test() {
	./unit-test && die
}

src_install(){
	python_foreach_impl python_doscript http-replicator

	newbin "${FILESDIR}"/${PN}-3.0-callrepcacheman-0.1 repcacheman

	python_foreach_impl python_domodule *.py

	python_foreach_impl python_newscript "${FILESDIR}"/${PN}-3.0-repcacheman-0.44-r2 repcacheman.py

	newinitd "${FILESDIR}"/${PN}-4.0_alpha2-r3.init http-replicator
	newconfd "${FILESDIR}"/${PN}-4.0_alpha2-r2.conf http-replicator

	systemd_dounit "${FILESDIR}"/http-replicator.service
	systemd_install_serviced "${FILESDIR}"/http-replicator.service.conf

	dodoc README.user README.devel RELNOTES
}

pkg_postinst() {
	echo
	einfo "Before starting ${PN}, please follow the next few steps:"
	einfo
	einfo "- Modify /etc/conf.d/${PN} if required."
	einfo "- Run \`repcacheman\` to set up the cache."
	einfo "- Add HTTP_PROXY=\"http://serveraddress:8080\" to make.conf on"
	einfo "  the server as well as on the client machines."
	einfo "- Make sure GENTOO_MIRRORS in /etc/portage/make.conf"
	einfo "  starts with several good HTTP mirrors."
	einfo
	einfo "For more information please refer to the following forum thread:"
	einfo
	einfo "  https://forums.gentoo.org/viewtopic-t-173226.html"
	einfo
	einfo "Starting with 4.x releases, the conf.d parameters have changed."
	echo
}
