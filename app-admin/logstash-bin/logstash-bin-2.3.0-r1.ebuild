# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit user

MY_PN="${PN/-bin}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Tool for managing events and logs"
HOMEPAGE="https://www.elastic.co/products/logstash"
SRC_URI="https://download.elastic.co/${MY_PN}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RESTRICT="strip"
QA_PREBUILT="opt/logstash/vendor/jruby/lib/jni/*/libjffi*.so"

DEPEND=""
RDEPEND="|| ( virtual/jre:1.8 virtual/jre:1.7 )"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	enewgroup ${MY_PN}
	enewuser ${MY_PN} -1 -1 /var/lib/${MY_PN} ${MY_PN} -m
}

src_install() {
	keepdir /etc/"${MY_PN}"/{conf.d,patterns,plugins}
	keepdir "/var/log/${MY_PN}"

	insinto "/etc/${MY_PN}/conf.d"
	doins "${FILESDIR}/agent.conf.sample"

	insinto "/opt/${MY_PN}"
	doins -r .
	fperms 0755 "/opt/${MY_PN}/bin/${MY_PN}" "/opt/${MY_PN}/vendor/jruby/bin/jruby"

	insinto /etc/logrotate.d
	newins "${FILESDIR}/${MY_PN}.logrotate-r2" "${MY_PN}"

	newconfd "${FILESDIR}/${MY_PN}.confd-r1" "${MY_PN}"
	newinitd "${FILESDIR}/${MY_PN}.initd-r2" "${MY_PN}"
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
