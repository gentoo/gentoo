# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/screenfetch/screenfetch-2.7.7.ebuild,v 1.4 2014/07/14 16:43:15 hwoarang Exp $

EAPI=4

MY_PN="${PN/f/F}"
DESCRIPTION="A Bash Screenshot Information Tool"
HOMEPAGE="https://github.com/KittyKatt/screenFetch"
SRC_URI="http://github.com/KittyKatt/${MY_PN}/zipball/v${PV} -> ${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="X"

DEPEND="app-arch/unzip"
RDEPEND="X? ( media-gfx/scrot x11-apps/xdpyinfo )"

GIT_HASH="4881270"
S="${WORKDIR}"/KittyKatt-${MY_PN}-${GIT_HASH}

src_install() {
	dobin ${PN}-dev
	# also known as screenfetch
	dosym ${PN}-dev /usr/bin/${PN}
	dodoc CHANGELOG README.mkdn TODO
}
