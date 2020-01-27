# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="prometheus monitoring system and time series database"
HOMEPAGE="http://prometheus.io"
MY_PN=${PN%%-bin}
MY_P=${MY_PN}-${PV}
SRC_URI="https://github.com/prometheus/prometheus/releases/download/v${PV}/${MY_P}.linux-amd64.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

QA_PREBUILT=".*"
RESTRICT="strip"

DEPEND="acct-group/prometheus
	acct-user/prometheus
	!app-metrics/prometheus"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}.linux-amd64"

src_install() {
	dobin prometheus promtool tsdb
	insinto /usr/share/prometheus
	doins -r console_libraries consoles
	insinto /etc/prometheus
	doins prometheus.yml
	dosym ../../usr/share/prometheus/console_libraries /etc/prometheus/console_libraries
	dosym ../../usr/share/prometheus/consoles /etc/prometheus/consoles

	newinitd "${FILESDIR}"/prometheus.initd prometheus
	newconfd "${FILESDIR}"/prometheus.confd prometheus
	keepdir /var/log/prometheus /var/lib/prometheus
	fowners prometheus:prometheus /var/log/prometheus /var/lib/prometheus
}

pkg_postinst() {
	if has_version '<net-analyzer/prometheus-2.0.0_rc0'; then
		ewarn "Old prometheus 1.x TSDB won't be converted to the new prometheus 2.0 format"
		ewarn "Be aware that the old data currently cannot be accessed with prometheus 2.0"
		ewarn "This release requires a clean storage directory and is not compatible with"
		ewarn "files created by previous beta releases"
	fi
}
