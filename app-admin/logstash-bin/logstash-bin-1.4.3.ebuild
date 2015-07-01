# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/logstash-bin/logstash-bin-1.4.3.ebuild,v 1.1 2015/07/01 08:04:27 idella4 Exp $

EAPI=5

MY_PN="${PN/-bin}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Tool for managing events and logs"
HOMEPAGE="https://www.elastic.co/products/logstash"
SRC_URI="https://download.elastic.co/${MY_PN}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="|| ( virtual/jre:1.8 virtual/jre:1.7 )"

S="${WORKDIR}/${MY_P}"

src_install() {
	keepdir /etc/"${MY_PN}"/{conf.d,patterns,plugins}
	keepdir "/var/log/${MY_PN}"

	insinto "/etc/${MY_PN}/conf.d"
	doins "${FILESDIR}/agent.conf.sample"

	insinto "/opt/${MY_PN}"
	doins -r .
	fperms 0755 "/opt/${MY_PN}/bin/${MY_PN}"

	insinto /etc/logrotate.d
	doins "${FILESDIR}/${MY_PN}.logrotate"

	newconfd "${FILESDIR}/${MY_PN}.confd" "${MY_PN}"
	newinitd "${FILESDIR}/${MY_PN}.initd" "${MY_PN}"
}

pkg_postinst() {
	einfo "Getting started with logstash:"
	einfo "  https://www.elastic.co/guide/en/logstash/current/getting-started-with-logstash.html"
	einfo ""
	einfo "Packages that might be interesting:"
	einfo "  app-misc/elasticsearch"
	einfo "  dev-python/elasticsearch-curator"
	einfo "  www-apps/kibana-bin"
}
