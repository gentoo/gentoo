# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils git-r3

MY_PN="${PN/f/F}"

DESCRIPTION="Bash Screenshot Information Tool"
HOMEPAGE="https://github.com/KittyKatt/screenFetch"
EGIT_REPO_URI="https://github.com/KittyKatt/screenFetch"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="X"

src_install() {
	newbin ${PN}-dev ${PN}
	dodoc CHANGELOG README.mkdn TODO
}

pkg_postinst() {
	optfeature "resoluton detection" x11-apps/xdpyinfo
	optfeature "screenshot taking" media-gfx/scrot
	optfeature "screenshot uploading" net-misc/curl
}
