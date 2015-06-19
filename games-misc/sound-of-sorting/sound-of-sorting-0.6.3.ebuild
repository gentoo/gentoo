# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-misc/sound-of-sorting/sound-of-sorting-0.6.3.ebuild,v 1.2 2013/12/02 05:19:13 patrick Exp $

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
