# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Lightweight log shipper for Logstash and Elasticsearch"
HOMEPAGE="https://www.elastic.co/products/beats"
SRC_URI="https://github.com/elastic/beats/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 BSD-2 MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"

DEPEND=">=dev-lang/go-1.12.9"
RDEPEND="!app-admin/filebeat-bin"

# Do not complain about CFLAGS etc since go projects do not use them.
QA_FLAGS_IGNORED='.*'

S="${WORKDIR}/src/github.com/elastic/beats"

src_unpack() {
	mkdir -p "${S%/*}" || die
	default
	mv beats-${PV} "${S}" || die
}

src_prepare() {
	default

	# avoid Elastic license
	rm -r x-pack || die

	# use ${PV} instead of git commit id
	sed -i "s/\(COMMIT_ID=\).*/\1${PV}/g" "${S}/libbeat/scripts/Makefile" || die
}

src_compile() {
	GOPATH="${WORKDIR}" emake -C "${S}/filebeat"
}

src_install() {
	keepdir /etc/${PN}
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
		elog "https://www.elastic.co/guide/en/beats/libbeat/$(ver_cut 1-2)/upgrading.html"
		elog ""
	fi

	elog "Example configurations:"
	elog "${EROOT}/usr/share/doc/${PF}/examples"
}
