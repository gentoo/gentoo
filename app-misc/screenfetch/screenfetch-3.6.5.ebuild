# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/screenfetch/screenfetch-3.6.5.ebuild,v 1.1 2015/02/01 12:58:08 hwoarang Exp $

EAPI=4

MY_PN="${PN/f/F}"
DESCRIPTION="A Bash Screenshot Information Tool"
HOMEPAGE="https://github.com/KittyKatt/screenFetch"
if [[ ${PV} == *9999* ]]; then
	inherit git-2
	EGIT_REPO_URI="https://github.com/KittyKatt/screenFetch"
	KEYWORDS=""
else
	SRC_URI="https://github.com/KittyKatt/${MY_PN}/archive/v${PV}.tar.gz -> \
		${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${PV}"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="X"

DEPEND=""
RDEPEND="X? ( media-gfx/scrot x11-apps/xdpyinfo )"

src_install() {
	newbin ${PN}-dev ${PN}
	dodoc CHANGELOG README.mkdn TODO
}
