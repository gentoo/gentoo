# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Simple information system script"
HOMEPAGE="https://github.com/dylanaraps/neofetch"
SRC_URI="https://github.com/dylanaraps/${PN}/archive/${PV}/${P}.tar.gz"
LICENSE="MIT-with-advertising"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X"

RDEPEND="sys-apps/pciutils
	X? (
		x11-apps/xprop
		x11-apps/xwininfo
		x11-apps/xrandr
		www-client/w3m[imlib]
		media-libs/imlib2
		media-gfx/imagemagick
	)"
