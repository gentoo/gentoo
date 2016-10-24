# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Lightweight log shipper for Logstash and Elasticsearch"
HOMEPAGE="https://www.elastic.co/products/beats"
SRC_URI="https://github.com/elastic/beats/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-lang/go"
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
	keepdir /etc/${PN}
	keepdir /var/lib/${PN}

	fperms 0750 /var/lib/${PN}

	newconfd "${FILESDIR}/${PN}.confd" ${PN}
	newinitd "${FILESDIR}/${PN}.initd" ${PN}

	insinto /etc/${PN}
	newins ${PN}/etc/${PN}.yml ${PN}.yml.example

	dobin filebeat/filebeat
}
