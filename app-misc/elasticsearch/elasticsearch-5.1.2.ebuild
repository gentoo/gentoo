# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils systemd user

DESCRIPTION="Open Source, Distributed, RESTful, Search Engine"
HOMEPAGE="https://www.elastic.co/products/elasticsearch"
SRC_URI="https://artifacts.elastic.co/downloads/${PN}/${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="strip"

RDEPEND="virtual/jre:1.8"

pkg_preinst() {
	if has_version '<app-misc/elasticsearch-2.3.2'; then
		export UPDATE_NOTES=1
	fi
}

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 /bin/bash /usr/share/${PN} ${PN}
}

src_prepare() {
	rm -rf bin/*.{bat,exe} || die
	rm LICENSE.txt || die

	default
}

src_install() {
	keepdir /etc/${PN}
	keepdir /etc/${PN}/scripts

	insinto /etc/${PN}
	doins config/*
	rm -rf config || die

	insinto /usr/share/${PN}
	doins -r ./*

	exeinto /usr/share/${PN}/bin
	doexe "${FILESDIR}/elasticsearch-systemd-pre-exec"

	chmod +x "${D}"/usr/share/${PN}/bin/* || die

	keepdir /var/{lib,log}/${PN}
	keepdir /usr/share/${PN}/plugins

	systemd_newtmpfilesd "${FILESDIR}/${PN}.tmpfiles.d" "${PN}.conf"

	insinto /etc/sysctl.d
	newins "${FILESDIR}/${PN}.sysctl.d" "${PN}.conf"

	newinitd "${FILESDIR}/${PN}.init7" "${PN}"
	newconfd "${FILESDIR}/${PN}.conf3" "${PN}"
	systemd_newunit "${FILESDIR}"/${PN}.service6 "${PN}.service"
}

pkg_postinst() {
	elog
	elog "You may create multiple instances of ${PN} by"
	elog "symlinking the init script:"
	elog "ln -sf /etc/init.d/${PN} /etc/init.d/${PN}.instance"
	elog
	elog "Please make sure you put elasticsearch.yml and logging.yml"
	elog "into the configuration directory of the instance:"
	elog "/etc/${PN}/instance"
	elog
	if ! [ -z ${UPDATE_NOTES} ]; then
		elog "This update changes some configuration variables. Please review"
		elog "${EROOT%/}/etc/conf.d/elasticsearch before restarting your services."
	fi
}
