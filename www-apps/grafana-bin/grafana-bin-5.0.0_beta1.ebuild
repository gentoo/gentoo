# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit user systemd

MY_PN=${PN/-bin/}
MY_SRC="${MY_PN}-${PV/_/-}.linux-x64.tar.gz"
S=${WORKDIR}/${MY_PN}-${PV/_/-}

DESCRIPTION="Gorgeous metric viz, dashboards & editors for Graphite, InfluxDB & OpenTSDB"
HOMEPAGE="http://grafana.org"
SRC_URI="https://s3-us-west-2.amazonaws.com/grafana-releases/release/${MY_SRC} -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""

DEPEND=""
RDEPEND="${DEPEND}"

QA_EXECSTACK="usr/share/grafana/vendor/phantomjs/phantomjs"
QA_PRESTRIPPED=${QA_EXECSTACK}

pkg_setup() {
	enewgroup grafana
	enewuser grafana -1 -1 /usr/share/grafana grafana
}

src_install() {
	keepdir /etc/grafana
	insinto /etc/grafana
	newins "${S}"/conf/sample.ini grafana.ini
	rm "${S}"/conf/sample.ini || die

	# Frontend assets
	insinto /usr/share/${MY_PN}
	doins -r public conf

	dobin bin/grafana-cli
	dobin bin/grafana-server

	newconfd "${FILESDIR}"/grafana.confd grafana
	newinitd "${FILESDIR}"/grafana.initd.3 grafana
	systemd_newunit "${FILESDIR}"/grafana.service grafana.service

	keepdir /var/{lib,log}/grafana
	keepdir /var/lib/grafana/{dashboards,plugins}
	fowners grafana:grafana /var/{lib,log}/grafana
	fowners grafana:grafana /var/lib/grafana/{dashboards,plugins}
	fperms 0750 /var/{lib,log}/grafana
	fperms 0750 /var/lib/grafana/{dashboards,plugins}
}

postinst() {
	elog "${PN} has built-in log rotation. Please see [log.file] section of"
	elog "/etc/grafana/grafana.ini for related settings."
	elog
	elog "You may add your own custom configuration for app-admin/logrotate if you"
	elog "wish to use external rotation of logs. In this case, you also need to make"
	elog "sure the built-in rotation is turned off."
}
