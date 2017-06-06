# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit user unpacker

DESCRIPTION="Scalable datastore for metrics, events, and real-time analytics"
HOMEPAGE="http://influxdb.com"
SRC_URI="https://dl.influxdata.com/influxdb/releases/${PN}_${PV}_amd64.deb"

RESTRICT="mirror"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 "/var/lib/${PN}" ${PN}
}

src_unpack() {
	mkdir -p ${WORKDIR}/${P}
	cd ${WORKDIR}/${P}
	unpack_deb ${A}
}

src_install() {
	cp -Rp * "${D}"
	newconfd "${FILESDIR}/${PN}.conf.d" "${PN}"
	newinitd "${FILESDIR}/${PN}.init.d" "${PN}"
}
