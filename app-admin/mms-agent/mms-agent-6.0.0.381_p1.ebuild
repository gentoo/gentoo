# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils user

MY_PV=${PV/_p/-}

DESCRIPTION="MongoDB MMS agents"
HOMEPAGE="https://www.mongodb.com/cloud"
SRC_URI="
	monitoring? (
		https://cloud.mongodb.com/download/agent/monitoring/mongodb-mms-monitoring-agent-${MY_PV}.linux_x86_64.tar.gz
	)
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+monitoring"

REQUIRED_USE="|| ( monitoring )"

RDEPEND="!<dev-db/mongodb-3.0.0[mms-agent]"
DEPEND="${RDEPEND}"

S="${WORKDIR}/mongodb-mms-monitoring-agent-${MY_PV}.linux_x86_64"

pkg_setup() {
	enewgroup mongodb
	enewuser mongodb -1 -1 /var/lib/${PN} mongodb
}

src_install() {
	if use monitoring; then
		local MY_PN="mms-monitoring-agent"
		local MY_D="/opt/${MY_PN}"

		insinto ${MY_D}
		doins mongodb-mms-monitoring-agent
		fperms +x "${MY_D}"/mongodb-mms-monitoring-agent

		insinto /etc
		doins monitoring-agent.config
		rm monitoring-agent.config
		dosym ../../etc/monitoring-agent.config ${MY_D}/monitoring-agent.config

		fowners -R mongodb:mongodb ${MY_D}
		newinitd "${FILESDIR}/${MY_PN}.initd" ${MY_PN}
	fi
}

pkg_postinst() {
	if use monitoring; then
		elog "MMS Monitoring Agent configuration file :"
		elog "  /etc/monitoring-agent.config"
	fi
}
