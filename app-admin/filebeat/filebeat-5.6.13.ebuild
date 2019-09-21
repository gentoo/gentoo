# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Lightweight log shipper for Logstash and Elasticsearch"
HOMEPAGE="https://www.elastic.co/products/beats"
SRC_URI="https://github.com/elastic/beats/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"

DEPEND=">=dev-lang/go-1.9.2"
RDEPEND="!app-admin/filebeat-bin"

# Do not complain about CFLAGS etc since go projects do not use them.
QA_FLAGS_IGNORED='.*'

S="${WORKDIR}/src/github.com/elastic/beats"

src_unpack() {
	mkdir -p "${S%/*}" || die
	default
	mv beats-${PV} "${S}" || die
}

src_compile() {
	GOPATH="${WORKDIR}" emake -C "${S}/filebeat"
}

src_install() {
	keepdir /var/{lib,log}/${PN}

	fperms 0750 /var/{lib,log}/${PN}

	newconfd "${FILESDIR}/${PN}.confd" ${PN}
	newinitd "${FILESDIR}/${PN}.initd" ${PN}

	docinto examples
	dodoc ${PN}/{filebeat.yml,filebeat.full.yml}

	insinto "/etc/${PN}"
	doins ${PN}/{filebeat.template.json,filebeat.template-es2x.json,filebeat.template-es6x.json}

	exeinto "/usr/share/${PN}"
	doexe libbeat/scripts/migrate_beat_config_1_x_to_5_0.py

	dobin filebeat/filebeat
}

pkg_postinst() {
	if [[ -n "${REPLACING_VERSIONS}" ]]; then
		elog "Please read the migration guide at:"
		elog "https://www.elastic.co/guide/en/beats/libbeat/$(ver_cut 1-2)/upgrading.html"
		elog ""
		elog "The migration script:"
		elog "${EROOT}/usr/share/filebeat/migrate_beat_config_1_x_to_5_0.py"
		elog ""
	fi

	elog "Example configurations:"
	elog "${EROOT}/usr/share/doc/${PF}/examples"
}
