# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake systemd

DESCRIPTION="Prometheus exporter for Gentoo Portage"
HOMEPAGE="https://github.com/projg2/portage-exporter"
SRC_URI="https://github.com/projg2/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-cpp/prometheus-cpp"

src_install() {
	cmake_src_install

	systemd_newunit "${FILESDIR}"/${PN}.service ${PN}.service
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
