# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/kibana-bin/kibana-bin-4.0.3.ebuild,v 1.1 2015/06/22 08:26:35 idella4 Exp $

EAPI=5

inherit user

MY_PN="kibana"
MY_P=${MY_PN}-${PV/_rc/-rc}

DESCRIPTION="visualize logs and time-stamped data"
HOMEPAGE="http://www.elasticsearch.org/overview/kibana/"
SRC_URI="https://download.elasticsearch.org/${MY_PN}/${MY_PN}/${MY_P}-linux-x64.tar.gz"

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

	newinitd "${FILESDIR}"/kibana.initd "${MY_PN}"

	mv * "${D}/opt/${MY_PN}"
}
