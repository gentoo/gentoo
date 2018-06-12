# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3
DESCRIPTION="Simple information system script"
HOMEPAGE="https://github.com/dylanaraps/neofetch"
EGIT_REPO_URI="https://github.com/dylanaraps/neofetch.git"
LICENSE="MIT-with-advertising"
SLOT="0"
IUSE="X"

RDEPEND="sys-apps/pciutils
	X? (
		media-gfx/imagemagick
		media-libs/imlib2
		www-client/w3m[imlib]
		x11-apps/xprop
		x11-apps/xrandr
		x11-apps/xwininfo
	)"
