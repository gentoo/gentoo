# Copyright 1999-2016 Gentoo Foundation
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

pkg_preinst() {
	if has_version '<app-misc/elasticsearch-2.3.2'; then
		export UPDATE_NOTES=1
	fi
}

pkg_setup() {
	enewgroup ${MY_PN}
	enewuser ${MY_PN} -1 /bin/bash /usr/share/${MY_PN} ${MY_PN}
	esethome ${MY_PN} /usr/share/${MY_PN}
}

src_prepare() {
	rm -rf bin/*.{bat,exe}
	rm LICENSE.txt
}

src_install() {
	dodir /etc/${MY_PN}
	dodir /etc/${MY_PN}/scripts

	insinto /etc/${MY_PN}
	doins config/*
	rm -rf config

	insinto /usr/share/${MY_PN}
	doins -r ./*

	insinto /usr/share/${MY_PN}/bin
	doins "${FILESDIR}/elasticsearch-systemd-pre-exec"

	chmod +x "${D}"/usr/share/${MY_PN}/bin/*

	keepdir /var/{lib,log}/${MY_PN}
	keepdir /usr/share/${MY_PN}/plugins

	insinto /usr/lib/tmpfiles.d
	newins "${FILESDIR}/${MY_PN}.tmpfiles.d" "${MY_PN}.conf"

	insinto /etc/sysctl.d
	newins "${FILESDIR}/${MY_PN}.sysctl.d" "${MY_PN}.conf"

	newinitd "${FILESDIR}/elasticsearch.init6" "${MY_PN}"
	newconfd "${FILESDIR}/${MY_PN}.conf2" "${MY_PN}"
	systemd_newunit "${FILESDIR}"/${PN}.service5 "${PN}.service"
}

pkg_postinst() {
	elog
	elog "You may create multiple instances of ${MY_PN} by"
	elog "symlinking the init script:"
	elog "ln -sf /etc/init.d/${MY_PN} /etc/init.d/${MY_PN}.instance"
	elog
	elog "Please make sure you put elasticsearch.yml and logging.yml"
	elog "into the configuration directory of the instance:"
	elog "/etc/${MY_PN}/instance"
	elog
	if ! [ -z ${UPDATE_NOTES} ]; then
		elog "This update changes some configuration variables. Please review"
		elog "/etc/conf.d/elasticsearch before restarting your services."
	fi
}
