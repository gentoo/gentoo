# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd

DESCRIPTION="UPnP Media Renderer front-end for MPD, the Music Player Daemon"
HOMEPAGE="https://www.lesbonscomptes.com/upmpdcli/index.html"
LICENSE="GPL-2"

SRC_URI="https://www.lesbonscomptes.com/upmpdcli/downloads/${P}.tar.gz"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="thirdparty"

DEPEND="
	dev-libs/jsoncpp
	media-libs/libmpdclient
	net-libs/libmicrohttpd
	net-libs/libupnpp
"
RDEPEND="
	${DEPEND}
	acct-group/upmpdcli
	acct-user/upmpdcli
	app-misc/recoll
	thirdparty? ( dev-python/requests )
"

src_install() {
	default
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	systemd_dounit systemd/upmpdcli.service
}

pkg_postinst() {
	einfo
	einfo "This package no longer assumes that upmpdcli is driving an"
	einfo "mpd instance on the same host (https://bugs.gentoo.org/670130)."
	einfo "Probably it is though, so be sure your mpd is built with"
	einfo "USE=curl."
}
