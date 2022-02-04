# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
MY_PN=${PN%-bin}

DESCRIPTION="Alerts dashboard for Prometheus Alertmanager"
HOMEPAGE="https://github.com/prymitive/karma"
SRC_URI="https://github.com/prymitive/${MY_PN}/releases/download/v${PV}/${MY_PN}-linux-amd64.tar.gz -> ${P}-amd64.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	acct-group/karma
	acct-user/karma"
	RDEPEND="${DEPEND}"

QA_PREBUILT="usr/bin/*"
RESTRICT="strip"
S="${WORKDIR}"

src_install() {
	dobin karma-linux-amd64
	dosym karma-linux-amd64 /usr/bin/karma
	insinto /etc/${MY_PN}
	newins "${FILESDIR}"/${MY_PN}-0.24.yaml ${MY_PN}.yaml
	newinitd "${FILESDIR}"/${MY_PN}.initd ${MY_PN}
keepdir /var/log/${MY_PN}
fowners ${MY_PN}:${MY_PN} /var/log/${MY_PN}
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		elog "Please edit ${EROOT}/etc/karma/karma.yaml to match your system."
	fi
}
