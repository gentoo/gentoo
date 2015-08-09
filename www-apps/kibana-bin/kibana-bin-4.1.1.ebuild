# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit user

MY_PN="kibana"
MY_P=${MY_PN}-${PV/_rc/-rc}

DESCRIPTION="visualize logs and time-stamped data"
HOMEPAGE="https://www.elastic.co/products/kibana"
SRC_URI="https://download.elastic.co/${MY_PN}/${MY_PN}/${MY_P}-linux-x64.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=app-misc/elasticsearch-1.4.4"

RESTRICT="strip"
QA_PREBUILT="opt/kibana/node/bin/node"

S="${WORKDIR}/${MY_P}-linux-x64"

pkg_setup() {
	enewgroup ${MY_PN}
	enewuser ${MY_PN} -1 -1 /opt/${MY_PN} ${MY_PN}
}

src_install() {
	keepdir /opt/${MY_PN}
	keepdir /var/log/${MY_PN}

	newinitd "${FILESDIR}"/kibana.initd-r1 "${MY_PN}"

	mv * "${D}/opt/${MY_PN}"
}
