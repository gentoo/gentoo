# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=6

DESCRIPTION="Simple information system script"
HOMEPAGE="https://github.com/dylanaraps/neofetch"
SRC_URI="https://github.com/dylanaraps/${PN}/archive/${PV}/${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
IUSE="X"

DEPEND="app-shells/bash:*
	sys-apps/pciutils"

RDEPEND="${DEPEND}
	X? ( x11-apps/xprop
	x11-apps/xwininfo
	x11-apps/xrandr
	www-client/w3m[imlib]
	media-libs/imlib2
	media-gfx/imagemagick
)"
