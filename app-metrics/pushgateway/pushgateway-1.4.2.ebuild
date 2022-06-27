# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module systemd

GIT_COMMIT="99981d7"
DESCRIPTION="Prometheus push acceptor for ephemeral and batch jobs"
HOMEPAGE="https://github.com/prometheus/pushgateway"
SRC_URI="
	https://github.com/prometheus/pushgateway/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~zmedico/dist/${P}-deps.tar.xz
"

LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	acct-group/pushgateway
	acct-user/pushgateway
"
DEPEND="${RDEPEND}"

BDEPEND=">=dev-util/promu-0.3.0"

src_prepare() {
	default
	sed -i -e 's|{{\.Revision}}|'${GIT_COMMIT}'|g' .promu.yml || die
}

src_compile() {
	mkdir -p bin || die
	promu build -v --prefix bin || die
}

src_install() {
	newbin "bin/${P}" "${PN}"
	dodoc {README,CHANGELOG,CONTRIBUTING}.md
	keepdir /var/log/${PN}
	fowners ${PN}:${PN} /var/log/${PN}
	newinitd "${FILESDIR}"/${PN}-1.initd ${PN}
	newconfd "${FILESDIR}"/${PN}-1.confd ${PN}
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}.logrotated" "${PN}"
	systemd_dounit "${FILESDIR}/${PN}-1.service"
}
