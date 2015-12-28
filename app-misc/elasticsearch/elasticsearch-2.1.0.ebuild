# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils systemd user

MY_PN="${PN%-bin}"
DESCRIPTION="Open Source, Distributed, RESTful, Search Engine"
HOMEPAGE="https://www.elastic.co/products/elasticsearch"
SRC_URI="https://download.elasticsearch.org/${MY_PN}/release/org/${MY_PN}/distribution/tar/${MY_PN}/${PV}/${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="strip"

RDEPEND="|| ( virtual/jre:1.8 virtual/jre:1.7 )"

pkg_setup() {
	enewgroup ${MY_PN}
	enewuser ${MY_PN} -1 /bin/bash /var/lib/${MY_PN} ${MY_PN}
}

src_prepare() {
	rm -rf bin/*.{bat,exe}
	rm LICENSE.txt
}

src_install() {
	dodir /etc/${MY_PN}
	dodir /etc/${MY_PN}/scripts

	insinto /usr/share/doc/${P}/examples
	doins config/*
	rm -rf config

	insinto /usr/share/${MY_PN}
	doins -r ./*
	chmod +x "${D}"/usr/share/${MY_PN}/bin/*

	keepdir /var/{lib,log}/${MY_PN}
	keepdir /usr/share/${MY_PN}/plugins

	newinitd "${FILESDIR}/elasticsearch.init5" "${MY_PN}"
	newconfd "${FILESDIR}/${MY_PN}.conf" "${MY_PN}"
	systemd_newunit "${FILESDIR}"/${PN}.service4 "${PN}.service"
}

pkg_postinst() {
	elog
	elog "You may create multiple instances of ${MY_PN} by"
	elog "symlinking the init script:"
	elog "ln -sf /etc/init.d/${MY_PN} /etc/init.d/${MY_PN}.instance"
	elog
	elog "Each of the example files in /usr/share/doc/${P}/examples"
	elog "should be extracted to the proper configuration directory:"
	elog "/etc/${MY_PN} (for standard init)"
	elog "/etc/${MY_PN}/instance (for symlinked init)"
	elog
}
