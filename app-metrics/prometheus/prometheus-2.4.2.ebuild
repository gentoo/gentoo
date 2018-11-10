# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit user golang-build golang-vcs-snapshot

EGO_PN="github.com/prometheus/prometheus"
MY_PV=${PV/_rc/-rc.}
EGIT_COMMIT="v${MY_PV}"
PROMETHEUS_COMMIT="c305ffa"
ARCHIVE_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Prometheus monitoring system and time series database"
HOMEPAGE="https://github.com/prometheus/prometheus"
SRC_URI="${ARCHIVE_URI}"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND="
	>=dev-lang/go-1.10
	dev-util/promu"

PROMETHEUS_HOME="/var/lib/prometheus"

RESTRICT="test"

pkg_setup() {
	enewgroup prometheus
	enewuser prometheus -1 -1 "${PROMETHEUS_HOME}" prometheus
}

src_prepare() {
	default
	sed -i -e "s/{{.Revision}}/${PROMETHEUS_COMMIT}/" src/${EGO_PN}/.promu.yml || die
}

src_compile() {
	pushd src/${EGO_PN} || die
	GOPATH="${S}" promu build -v || die
	popd || die
}

src_install() {
	pushd src/${EGO_PN} || die
	dobin promtool prometheus
	dodoc -r {documentation,{README,CHANGELOG,CONTRIBUTING}.md}
	insinto /etc/prometheus
	doins documentation/examples/prometheus.yml
	insinto /usr/share/prometheus
	doins -r console_libraries consoles
	dosym ../../usr/share/prometheus/console_libraries /etc/prometheus/console_libraries
	dosym ../../usr/share/prometheus/consoles /etc/prometheus/consoles
	popd || die

	newinitd "${FILESDIR}"/prometheus-3.initd prometheus
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
