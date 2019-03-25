# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

XORG_STATIC=no
inherit xorg-3

DESCRIPTION="X Compositing manager"
HOMEPAGE="https://freedesktop.org/wiki/Software/xapps"
SRC_URI="https://www.x.org/releases/individual/app/${P}.tar.bz2"

LICENSE="BSD"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND="
	x11-libs/libXrender
	x11-libs/libXdamage
	x11-libs/libXfixes
	x11-libs/libXcomposite
	x11-libs/libXext
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
