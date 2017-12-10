# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
EGO_PN="github.com/google/cadvisor"

inherit user golang-build golang-vcs-snapshot
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="Analyzes resource usage and performance characteristics of running containers"

HOMEPAGE="https://github.com/google/cadvisor"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /dev/null ${PN}
}

src_install() {
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	dobin ${PN}
}
