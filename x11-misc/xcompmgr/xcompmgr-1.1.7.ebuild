# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

XORG_STATIC=no
inherit xorg-2

DESCRIPTION="X Compositing manager"
HOMEPAGE="https://freedesktop.org/Software/xapps"
SRC_URI="http://xorg.freedesktop.org/releases/individual/app/${P}.tar.bz2"

LICENSE="BSD"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE=""

RDEPEND="
	x11-libs/libXrender
	x11-libs/libXdamage
	x11-libs/libXfixes
	x11-libs/libXcomposite
	x11-libs/libXext
"
DEPEND="${RDEPEND}"
