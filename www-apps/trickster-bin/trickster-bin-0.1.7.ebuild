# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
MY_PN=${PN%-bin}
MY_P=${MY_PN}-${PV}

inherit user systemd

DESCRIPTION="Dashboard Accelerator for Prometheus"
HOMEPAGE="https://github.com/Comcast/trickster"
SRC_URI="https://github.com/Comcast/trickster/releases/download/v${PV}/${MY_P}.linux-amd64.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

QA_PREBUILT="usr/bin/*"

S="${WORKDIR}"

pkg_setup() {
	enewgroup ${MY_PN}
	enewuser ${MY_PN} -1 -1 -1 ${MY_PN}
}

src_install() {
dobin ${MY_P}.linux-amd64
dosym ${MY_P}.linux-amd64 /usr/bin/${MY_PN}
insinto /etc/trickster
doins "${FILESDIR}"/trickster.conf
newinitd "${FILESDIR}"/${MY_PN}.initd ${MY_PN}
systemd_dounit "${FILESDIR}"/trickster.service
keepdir /var/log/${MY_PN}
fowners ${MY_PN}:${MY_PN} /var/log/${MY_PN}
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
	elog "Please edit ${EROOT}/etc/trickster/trickster.conf for your setup."
	fi
}
