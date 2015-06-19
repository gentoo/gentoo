# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/logstash-forwarder/logstash-forwarder-0.4.0.ebuild,v 1.1 2015/03/20 16:06:41 aidecoe Exp $

EAPI=5

inherit user

DESCRIPTION="Collects logs locally in preparation for processing elsewhere"
HOMEPAGE="https://github.com/elastic/logstash-forwarder"
SRC_URI="https://github.com/elastic/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/go"
RDEPEND="${DEPEND}"

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
}

pkg_postinst() {
	if ! [[ -e /etc/${PN}/${PN}.conf ]]; then
		elog "Before starting logstash-forwarder create config file at"
		elog
		elog "  /etc/${PN}/${PN}.conf"
		elog
		elog "See example in /usr/share/doc/${PVR} directory. You can remove"
		elog "-quiet from logstash-forward arguments in /etc/conf.d/${PN} to"
		elog "until you get working configuration. Search syslog for errors."
	fi
}
