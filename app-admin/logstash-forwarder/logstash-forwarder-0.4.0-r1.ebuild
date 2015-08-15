# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit user

DESCRIPTION="Collects logs locally in preparation for processing elsewhere"
HOMEPAGE="https://github.com/elastic/logstash-forwarder"
SRC_URI="https://github.com/elastic/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/go:="
RDEPEND=""

pkg_setup() {
	enewgroup logstash
	enewuser logstash -1 -1 -1 logstash
}

src_install() {
	dobin "${PN}"
	dodir "/etc/${PN}"
	dodoc "${PN}".conf.example CHANGELOG README.md
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"

	local statedir="/var/lib/${PN}"
	keepdir "$statedir"
	fowners logstash:logstash "$statedir"
	fperms 0750 "$statedir"
}

pkg_postinst() {
	if ! [[ -e /etc/${PN}/${PN}.conf ]]; then
		elog "Before starting logstash-forwarder create config file at"
		elog
		elog "  /etc/${PN}/${PN}.conf"
		elog
		elog "See example in /usr/share/doc/${PN}-${PVR} directory. You can"
		elog "remove -quiet from logstash-forward arguments in"
		elog "/etc/conf.d/${PN} until you get working configuration."
		elog "Search syslog for errors."
	fi
}
