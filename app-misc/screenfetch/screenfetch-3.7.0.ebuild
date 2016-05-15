# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils

MY_PN="${PN/f/F}"

DESCRIPTION="Bash Screenshot Information Tool"
HOMEPAGE="https://github.com/KittyKatt/screenFetch"
SRC_URI="https://github.com/KittyKatt/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X"

S="${WORKDIR}/${MY_PN}-${PV}"

src_install() {
	newbin ${PN}-dev ${PN}
	dodoc CHANGELOG README.mkdn TODO
}

pkg_postinst() {
	optfeature "resoluton detection" x11-apps/xdpyinfo
	optfeature "screenshot taking" media-gfx/scrot
	optfeature "screenshot uploading" net-misc/curl
}
