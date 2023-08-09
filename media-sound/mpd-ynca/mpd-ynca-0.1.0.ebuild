# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="MPD client to control Yamaha AV receivers with YNCA (network control) support"
HOMEPAGE="https://github.com/chewi/mpd-ynca"
SRC_URI="https://github.com/chewi/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~arm ~arm64"
LICENSE="GPL-2+"
SLOT="0"

RDEPEND="
	acct-user/mpd
	dev-libs/boost:=
	media-libs/libmpdclient
"

DEPEND="
	${RDEPEND}
"

BDEPEND="
	virtual/pkgconfig
"

src_install() {
	meson_src_install
	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}
}
