# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd

MY_PN="${PN%-bin}"
MY_P=${MY_PN}-${PV}

DESCRIPTION="Analytics and search dashboard for Elasticsearch"
HOMEPAGE="https://www.elastic.co/products/kibana"
SRC_URI="x-pack? ( https://artifacts.elastic.co/downloads/${MY_PN}/${MY_P}-linux-x86_64.tar.gz )
	!x-pack? ( https://artifacts.elastic.co/downloads/${MY_PN}/${MY_PN}-oss-${PV}-linux-x86_64.tar.gz )"

# source: LICENSE.txt and NOTICE.txt
LICENSE="Apache-2.0 Artistic-2 BSD BSD-2 CC-BY-3.0 CC-BY-4.0 icu ISC MIT MPL-2.0 OFL-1.1 openssl public-domain Unlicense WTFPL-2 ZLIB x-pack? ( Elastic )"
SLOT="0"
KEYWORDS="~amd64"
IUSE="x-pack"

RDEPEND="
	acct-group/kibana
	acct-user/kibana
	>=net-libs/nodejs-10.15.2
	x-pack? (
		dev-libs/expat
		dev-libs/nss
	)"

S="${WORKDIR}/${MY_P}-linux-x86_64"

src_prepare() {
	default

	# remove empty unused directory
	rmdir data || die

	# remove bundled nodejs
	rm -r node || die
	sed -i 's@\(^NODE="\).*@\1/usr/bin/node"@g' \
		bin/kibana || die

	# move optimize/plugins to /var/lib/kibana
	rm -r optimize plugins || die

	# handle node.js version with RDEPEND
	sed -i /node_version_validator/d src/setup_node_env/index.js || die
}

src_install() {
	insinto /etc/${MY_PN}
	doins -r config/.
	rm -r config || die

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${MY_PN}.logrotate ${MY_PN}

	newconfd "${FILESDIR}"/${MY_PN}.confd ${MY_PN}
	newinitd "${FILESDIR}"/${MY_PN}.initd ${MY_PN}
	systemd_dounit "${FILESDIR}"/${MY_PN}.service

	insinto /opt/${MY_PN}
	doins -r .

	fperms -R +x /opt/${MY_PN}/bin

	diropts -m 0750 -o ${MY_PN} -g ${MY_PN}
	keepdir /var/lib/${MY_PN}/optimize
	keepdir /var/lib/${MY_PN}/plugins
	keepdir /var/log/${MY_PN}

	dosym ../../var/lib/kibana/optimize /opt/kibana/optimize # Bug 667214
	dosym ../../var/lib/kibana/plugins /opt/kibana/plugins
}

pkg_postinst() {
	ewarn "Kibana optimize/plugins directories were moved to /var/lib/kibana."
	ewarn "In case of startup failures (FATAL Error: Cannot find module...),"
	ewarn "please remove the optimize directory content:"
	ewarn "rm -r /var/lib/kibana/optimize/*"
	elog "This version of Kibana is compatible with Elasticsearch $(ver_cut 1-2) and"
	elog "Node.js 10. Some plugins may fail with other versions of Node.js (Bug #656008)."
	elog
	elog "To set a customized Elasticsearch instance:"
	elog "  OpenRC: set ES_INSTANCE in /etc/conf.d/${MY_PN}"
	elog "  systemd: set elasticsearch.url in /etc/${MY_PN}/kibana.yml"
	elog
	elog "Elasticsearch can run local or remote."
}
