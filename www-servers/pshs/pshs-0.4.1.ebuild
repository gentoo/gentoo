# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Pretty small HTTP server -- a command-line tool to share files"
HOMEPAGE="https://github.com/mgorny/pshs/"
SRC_URI="
	https://github.com/mgorny/pshs/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+magic qrcode ssl upnp"

RDEPEND=">=dev-libs/libevent-2:0=
	magic? ( sys-apps/file:0= )
	qrcode? ( media-gfx/qrencode:0= )
	ssl? ( >=dev-libs/libevent-2.1:0=[ssl]
		dev-libs/openssl:0=
	)
	upnp? ( net-libs/miniupnpc:0= )"
DEPEND="${RDEPEND}"

src_configure() {
	local emesonargs=(
		$(meson_feature magic libmagic)
		$(meson_feature qrcode qrencode)
		$(meson_feature ssl)
		$(meson_feature upnp)
	)

	meson_src_configure
}
