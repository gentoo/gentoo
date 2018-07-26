# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="a dockapp to display disk space usage"
HOMEPAGE="http://tnemeth.free.fr/projets/dockapps.html"
SRC_URI="http://tnemeth.free.fr/projets/programmes/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	x11-libs/libXt"
