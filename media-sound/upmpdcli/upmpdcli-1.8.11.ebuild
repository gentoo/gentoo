# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson systemd

DESCRIPTION="UPnP Media Renderer front-end for MPD, the Music Player Daemon"
HOMEPAGE="https://www.lesbonscomptes.com/upmpdcli/index.html"

SRC_URI="https://www.lesbonscomptes.com/upmpdcli/downloads/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="thirdparty"

DEPEND="
	net-misc/curl
	dev-libs/jsoncpp
	media-libs/libmpdclient
	net-libs/libmicrohttpd:=
	>net-libs/libupnpp-0.26.4
"
RDEPEND="
	${DEPEND}
	acct-group/upmpdcli
	acct-user/upmpdcli
	app-misc/recoll
	thirdparty? ( dev-python/requests )
"

src_install() {
	meson_src_install
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	systemd_dounit systemd/upmpdcli.service
}
