# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Lightweight log shipper for Logstash and Elasticsearch"
HOMEPAGE="https://www.elastic.co/products/beats"
SRC_URI="https://github.com/elastic/beats/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=dev-lang/go-1.7.1"
RDEPEND="!app-admin/filebeat-bin"

ELASTIC="${WORKDIR}/src/github.com/elastic"
BEATS="${ELASTIC}/beats"
S="${BEATS}"

src_unpack() {
	mkdir -p "${ELASTIC}" || die
	unpack ${P}.tar.gz
	mv beats-${PV} "${BEATS}" || die
}

src_compile() {
	cd ${BEATS}/filebeat || die
	GOPATH="${WORKDIR}" emake
}

src_test() {
	cd ${BEATS}/filebeat || die
	GOPATH="${WORKDIR}" emake check
}

src_install() {
	keepdir /var/{lib,log}/${PN}

	fperms 0750 /var/{lib,log}/${PN}

	newconfd "${FILESDIR}/${PN}.confd" ${PN}
	newinitd "${FILESDIR}/${PN}.initd" ${PN}

	insinto "/usr/share/doc/${PF}/examples"
	doins ${PN}/{filebeat.yml,filebeat.full.yml}

	insinto "/etc/${PN}"
	doins ${PN}/{filebeat.template.json,filebeat.template-es2x.json}

	exeinto "/usr/share/${PN}"
	doexe libbeat/scripts/migrate_beat_config_1_x_to_5_0.py

	dobin filebeat/filebeat
}

pkg_postinst() {
	if [[ -n "${REPLACING_VERSIONS}" ]]; then
		elog "Please read the migration guide at:"
		elog "https://www.elastic.co/guide/en/beats/libbeat/5.0/upgrading.html"
		elog ""
		elog "The migration script:"
		elog "${EROOT%/}/usr/share/filebeat/migrate_beat_config_1_x_to_5_0.py"
		elog ""
	fi

	elog "Example configurations:"
	elog "${EROOT%/}/usr/share/doc/${PF}/examples"
}
