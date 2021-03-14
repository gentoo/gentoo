# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module systemd

MY_PV=v${PV/_rc/-rc.}
GIT_COMMIT=e83ef207b

DESCRIPTION="Prometheus monitoring system and time series database"
HOMEPAGE="https://github.com/prometheus/prometheus"
SRC_URI="https://github.com/prometheus/prometheus/archive/${MY_PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~williamh/dist/${P}-assets.tar.gz"

LICENSE="Apache-2.0 BSD BSD-2 ISC MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm"

COMMON_DEPEND="acct-group/prometheus
	acct-user/prometheus"
DEPEND="!app-metrics/prometheus-bin
	${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"
BDEPEND=">=dev-util/promu-0.3.0"

RESTRICT+=" test"

src_prepare() {
	default
	sed -i -e "s/{{.Revision}}/${GIT_COMMIT}/" .promu.yml || die
	mv ../assets_vfsdata.go web/ui || die
}

src_compile() {
	promu build --prefix bin -v || die
}

src_install() {
	dobin bin/*
	dodoc -r {documentation,{README,CHANGELOG,CONTRIBUTING}.md}
	insinto /etc/prometheus
	doins documentation/examples/prometheus.yml
	insinto /usr/share/prometheus
	doins -r console_libraries consoles
	dosym ../../usr/share/prometheus/console_libraries /etc/prometheus/console_libraries
	dosym ../../usr/share/prometheus/consoles /etc/prometheus/consoles

	systemd_dounit "${FILESDIR}"/prometheus.service
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
