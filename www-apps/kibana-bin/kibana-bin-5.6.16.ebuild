# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit user

MY_PN="${PN%-bin}"
MY_P=${MY_PN}-${PV}

DESCRIPTION="Analytics and search dashboard for Elasticsearch"
HOMEPAGE="https://www.elastic.co/products/kibana"
SRC_URI="https://artifacts.elastic.co/downloads/${MY_PN}/${MY_P}-linux-x86_64.tar.gz"

# source: LICENSE.txt and NOTICE.txt
LICENSE="Apache-2.0 Artistic-2 BSD BSD-2 CC-BY-3.0 CC-BY-4.0 icu ISC MIT MPL-2.0 OFL-1.1 openssl public-domain Unlicense WTFPL-2 ZLIB"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=net-libs/nodejs-6.17.0"

# Do not complain about CFLAGS etc since kibana does not use them.
QA_FLAGS_IGNORED='.*'

S="${WORKDIR}/${MY_P}-linux-x86_64"

pkg_setup() {
	enewgroup ${MY_PN}
	enewuser ${MY_PN} -1 -1 /opt/${MY_PN} ${MY_PN}
}

src_prepare() {
	default

	# remove bundled nodejs
	rm -r node || die

	# remove empty unused directory
	rmdir data || die
}

src_install() {
	insinto /etc/${MY_PN}
	doins -r config/.
	rm -r config || die

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${MY_PN}.logrotate ${MY_PN}

	newconfd "${FILESDIR}"/${MY_PN}.confd ${MY_PN}
	newinitd "${FILESDIR}"/${MY_PN}.initd ${MY_PN}

	insinto /opt/${MY_PN}
	doins -r .

	fperms -R +x /opt/${MY_PN}/bin

	diropts -m 0750 -o ${MY_PN} -g ${MY_PN}
	keepdir /var/log/${MY_PN}
}

pkg_postinst() {
	elog "This version of Kibana is compatible with Elasticsearch $(ver_cut 1-2) and"
	elog "Node.js 6. Some plugins may fail with other versions of Node.js (Bug #656008)."
	elog
	elog "Be sure to point ES_INSTANCE to your Elasticsearch instance"
	elog "in /etc/conf.d/${MY_PN}."
	elog
	elog "Elasticsearch can run local or remote."
}
