# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd tmpfiles

DESCRIPTION="Open Source, Distributed, RESTful, Search Engine"
HOMEPAGE="https://www.elastic.co/products/elasticsearch"
SRC_URI="x-pack? ( https://artifacts.elastic.co/downloads/${PN}/${P}-no-jdk-linux-x86_64.tar.gz )
	!x-pack? ( https://artifacts.elastic.co/downloads/${PN}/${PN}-oss-${PV}-no-jdk-linux-x86_64.tar.gz )"
LICENSE="Apache-2.0 BSD-2 LGPL-3 MIT public-domain x-pack? ( Elastic )"
SLOT="0"
KEYWORDS="~amd64"
IUSE="x-pack"

RDEPEND="acct-group/elasticsearch
	acct-user/elasticsearch
	virtual/jre"

QA_PRESTRIPPED="usr/share/elasticsearch/modules/x-pack-ml/platform/linux-x86_64/\(bin\|lib\)/.*"

src_prepare() {
	default

	rm LICENSE.txt NOTICE.txt || die
	rmdir logs || die
}

src_install() {
	keepdir /etc/${PN}
	keepdir /etc/${PN}/scripts

	insinto /etc/${PN}
	doins -r config/.
	rm -r config || die

	fowners root:${PN} /etc/${PN}
	fperms 2750 /etc/${PN}

	insinto /usr/share/${PN}
	doins -r .

	exeinto /usr/share/${PN}/bin
	doexe "${FILESDIR}/elasticsearch-systemd-pre-exec"

	fperms -R +x /usr/share/${PN}/bin

	if use x-pack; then
		fperms -R +x /usr/share/${PN}/modules/x-pack-ml/platform/linux-x86_64/bin
	fi

	keepdir /var/{lib,log}/${PN}
	fowners ${PN}:${PN} /var/{lib,log}/${PN}
	fperms 0750 /var/{lib,log}/${PN}
	dodir /usr/share/${PN}/plugins

	insinto /etc/sysctl.d
	newins "${FILESDIR}/${PN}.sysctl.d" ${PN}.conf

	newconfd "${FILESDIR}/${PN}.conf.3" ${PN}
	newinitd "${FILESDIR}/${PN}.init.7" ${PN}

	systemd_install_serviced "${FILESDIR}/${PN}.service.conf"
	systemd_newunit "${FILESDIR}"/${PN}.service.3 ${PN}.service

	newtmpfiles "${FILESDIR}"/${PN}.tmpfiles.d ${PN}.conf
}

pkg_postinst() {
	tmpfiles_process /usr/lib/tmpfiles.d/${PN}.conf

	elog
	elog "You may create multiple instances of ${PN} by"
	elog "symlinking the init script:"
	elog "ln -sf /etc/init.d/${PN} /etc/init.d/${PN}.instance"
	elog
	elog "Please make sure you put elasticsearch.yml, log4j2.properties and scripts"
	elog "from /etc/${PN} into the configuration directory of the instance:"
	elog "/etc/${PN}/instance"
	elog
	ewarn "Please make sure you have proper permissions on /etc/${PN}"
	ewarn "prior to keystore generation or you may experience startup fails."
	ewarn "chown root:${PN} /etc/${PN} && chmod 2750 /etc/${PN}"
	ewarn "chown root:${PN} /etc/${PN}/${PN}.keystore && chmod 0660 /etc/${PN}/${PN}.keystore"
}
