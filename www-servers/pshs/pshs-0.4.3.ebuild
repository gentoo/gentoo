# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Pretty small HTTP server -- a command-line tool to share files"
HOMEPAGE="https://github.com/projg2/pshs/"
SRC_URI="
	https://github.com/projg2/pshs/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+magic qrcode ssl upnp"

DEPEND="
	>=dev-libs/libevent-2.1:=
	magic? ( sys-apps/file:= )
	qrcode? ( media-gfx/qrencode:= )
	ssl? (
		>=dev-libs/libevent-2.1:=[ssl]
		dev-libs/openssl:0=
	)
	upnp? ( net-libs/miniupnpc:= )
"
RDEPEND="
	${DEPEND}
"

src_configure() {
	local emesonargs=(
		$(meson_feature magic libmagic)
		$(meson_feature qrcode qrencode)
		$(meson_feature ssl)
		$(meson_feature upnp)
	)

	meson_src_configure
}
