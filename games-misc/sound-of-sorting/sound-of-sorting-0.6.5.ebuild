# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-misc/sound-of-sorting/sound-of-sorting-0.6.5.ebuild,v 1.1 2014/05/16 10:23:54 blueness Exp $

EAPI=5

inherit games

DESCRIPTION="Visualization and Audibilization of Sorting Algorithms"
HOMEPAGE="http://panthema.net/2013/sound-of-sorting/"
SRC_URI="http://panthema.net/2013/sound-of-sorting/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="media-libs/libsdl
	x11-libs/wxGTK"
RDEPEND="${DEPEND}"
