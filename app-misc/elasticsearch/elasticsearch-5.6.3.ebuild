# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit systemd user

DESCRIPTION="Open Source, Distributed, RESTful, Search Engine"
HOMEPAGE="https://www.elastic.co/products/elasticsearch"
SRC_URI="https://artifacts.elastic.co/downloads/${PN}/${P}.tar.gz"
LICENSE="Apache-2.0 BSD-2 LGPL-3 MIT public-domain"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="virtual/jre:1.8"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 /bin/bash /usr/share/${PN} ${PN}
}

src_prepare() {
	rm -v bin/*.{bat,exe} LICENSE.txt || die

	default
}

src_install() {
	keepdir /etc/${PN}
	keepdir /etc/${PN}/scripts

	insinto /etc/${PN}
	doins config/*
	rm -rv config || die

	insinto /usr/share/${PN}
	doins -r ./*

	exeinto /usr/share/${PN}/bin
	doexe "${FILESDIR}/elasticsearch-systemd-pre-exec"

	chmod +x "${ED}"/usr/share/${PN}/bin/* || die

	keepdir /var/{lib,log}/${PN}
	dodir /usr/share/${PN}/plugins

	systemd_newtmpfilesd "${FILESDIR}/${PN}.tmpfiles.d" "${PN}.conf"

	insinto /etc/sysctl.d
	newins "${FILESDIR}/${PN}.sysctl.d" "${PN}.conf"

	newinitd "${FILESDIR}/${PN}.init" "${PN}"
	newconfd "${FILESDIR}/${PN}.conf" "${PN}"
	systemd_newunit "${FILESDIR}"/${PN}.service "${PN}.service"
}

pkg_postinst() {
	elog
	elog "You may create multiple instances of ${PN} by"
	elog "symlinking the init script:"
	elog "ln -sf /etc/init.d/${PN} /etc/init.d/${PN}.instance"
	elog
	elog "Please make sure you put elasticsearch.yml, log4j2.properties and scripts"
	elog "from /etc/elasticsearch into the configuration directory of the instance:"
	elog "/etc/${PN}/instance"
	elog
}
