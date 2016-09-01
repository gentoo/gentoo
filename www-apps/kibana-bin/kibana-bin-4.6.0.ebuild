# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit pax-utils user

MY_PN="kibana"
MY_P=${MY_PN}-${PV/_rc/-rc}

DESCRIPTION="Explore and visualize data"
HOMEPAGE="https://www.elastic.co/products/kibana"
SRC_URI="amd64? ( https://download.elastic.co/${MY_PN}/${MY_PN}/${MY_P}-linux-x86_64.tar.gz )
	x86? ( https://download.elastic.co/${MY_PN}/${MY_PN}/${MY_P}-linux-x86.tar.gz )"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RESTRICT="strip"
QA_PREBUILT="opt/kibana/node/bin/node"

pkg_setup() {
	enewgroup ${MY_PN}
	enewuser ${MY_PN} -1 -1 /opt/${MY_PN} ${MY_PN}
}

src_unpack() {
	if use amd64; then
	  S="${WORKDIR}/${MY_P}-linux-x86_64"
	elif use x86; then
	  S="${WORKDIR}/${MY_P}-linux-x86"
	fi

	default
}

src_install() {
	keepdir /opt/${MY_PN}
	keepdir /var/log/${MY_PN}
	keepdir /etc/${MY_PN}

	insinto /etc/${MY_PN}
	doins config/*
	rm -rf config

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/${MY_PN}.logrotate ${MY_PN}

	newconfd "${FILESDIR}"/${MY_PN}.confd ${MY_PN}
	newinitd "${FILESDIR}"/${MY_PN}.initd-r3 ${MY_PN}

	mv * "${D}"/opt/${MY_PN}

	# bug 567934
	pax-mark m "${ED}/opt/${MY_PN}/node/bin/node"
}

pkg_postinst() {
	elog "This version of Kibana is compatible with Elasticsearch 2.3+"
	elog
	elog "Be sure to point ES_INSTANCE to your Elasticsearch instance"
	elog "in /etc/conf.d/${MY_PN}."
	elog
	elog "Elasticsearch can run local or remote."
}
