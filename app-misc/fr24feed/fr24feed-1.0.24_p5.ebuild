# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="${PV/-/_}"
MY_PV="${MY_PV/_p/-}"
MY_P="${PN}_${MY_PV}"

DESCRIPTION="Flightradar24 data sharing software"
HOMEPAGE="https://www.flightradar24.com/share-your-data"
SRC_URI="
	amd64? ( https://repo-feed.flightradar24.com/linux_x86_64_binaries/${MY_P}_amd64.tgz )
	x86? ( https://repo-feed.flightradar24.com/linux_x86_binaries/${MY_P}_i386.tgz )
"

LICENSE="Flightradar24"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"

RDEPEND="
	net-wireless/dump1090
	virtual/libusb:1
"

RESTRICT="bindist mirror"

S="${WORKDIR}"

QA_PREBUILT="usr/bin/fr24feed"

src_install() {
	dobin fr24feed_$(usex amd64 'amd64' 'i386')/fr24feed

	insinto /etc
	doins "${FILESDIR}"/fr24feed.ini

	newinitd "${FILESDIR}"/fr24feed.initd fr24feed
	newconfd "${FILESDIR}"/fr24feed.confd fr24feed
}

pkg_postinst() {
	elog "Please run '/usr/bin/fr24feed --signup', to register yourself as a data feeder."
}
