# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit versionator

DESCRIPTION="Lightweight log shipper for Logstash and Elasticsearch"
HOMEPAGE="https://www.elastic.co/products/beats"
SRC_URI="https://github.com/elastic/beats/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"

DEPEND=">=dev-lang/go-1.9.2"
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

src_install() {
	keepdir /var/{lib,log}/${PN}

	fperms 0750 /var/{lib,log}/${PN}

	newconfd "${FILESDIR}/${PN}.confd" ${PN}
	newinitd "${FILESDIR}/${PN}.initd.1" ${PN}

	docinto examples
	dodoc ${PN}/{filebeat.yml,filebeat.reference.yml}

	dobin filebeat/filebeat
}

pkg_postinst() {
	if [[ -n "${REPLACING_VERSIONS}" ]]; then
		elog "Please read the migration guide at:"
		elog "https://www.elastic.co/guide/en/beats/libbeat/$(get_version_component_range 1-2)/upgrading.html"
		elog ""
	fi

	elog "Example configurations:"
	elog "${EROOT%/}/usr/share/doc/${PF}/examples"
}
