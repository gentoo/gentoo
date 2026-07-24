# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module systemd

DESCRIPTION="Alertmanager for alerts sent by client applications such as Prometheus"
HOMEPAGE="https://github.com/prometheus/alertmanager"
SRC_URI="
	https://github.com/prometheus/alertmanager/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/prometheus/alertmanager/releases/download/v${PV}/${PN}-web-ui-${PV}.tar.gz
	https://github.com/gentoo-golang-dist/alertmanager/releases/download/v${PV}/${P}-vendor.tar.xz
"
LICENSE="Apache-2.0 BSD BSD-2 MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

# tests don't work due to "missing files"
RESTRICT+=" test"

BDEPEND="
	>=dev-lang/go-1.25.0
	dev-util/promu
"
DEPEND="
	acct-group/alertmanager
	acct-user/alertmanager
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/0.33.0-promu-config.patch" )

src_prepare() {
	default

	# put UI assets in place
	cp -a "${WORKDIR}"/dist ui/app || die
}

src_compile() {
	promu build -v --prefix bin || die
}

src_install() {
	dobin bin/*
	dodoc {README,CHANGELOG}.md
	insinto /etc/alertmanager/
	newins doc/examples/simple.yml config.yml
	keepdir /var/lib/alertmanager /var/log/alertmanager
	systemd_dounit "${FILESDIR}"/alertmanager.service
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
	fowners ${PN}:${PN} /etc/alertmanager /var/lib/alertmanager /var/log/alertmanager
}
