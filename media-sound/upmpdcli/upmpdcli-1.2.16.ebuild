# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit user

DESCRIPTION="UPnP Media Renderer front-end for MPD, the Music Player Daemon"
HOMEPAGE="https://www.lesbonscomptes.com/upmpdcli/index.html"
LICENSE="GPL-2"

SRC_URI="https://www.lesbonscomptes.com/upmpdcli/downloads/${P}.tar.gz"
SLOT="0"
KEYWORDS="~amd64"
IUSE="thirdparty"

DEPEND="
	dev-libs/jsoncpp
	media-libs/libmpdclient
	net-libs/libmicrohttpd
	net-libs/libupnpp
"
RDEPEND="
	${DEPEND}
	thirdparty? ( dev-python/requests )
	media-sound/mpd[curl]
"

pkg_setup() {
	enewuser "${PN}"
	enewgroup "${PN}"
}

src_install() {
	default
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
}

pkg_postinst() {
	einfo
	einfo "Consider installing media-sound/sc2mpd.  If upmpdcli"
	einfo "detects sc2mpd at run-time, capabilities are added"
	einfo "including internet radio support.  See upstream docs"
	einfo "for more information."
}
