# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Linux port of the classical Atari ST game Ballerburg"
HOMEPAGE="http://baller.tuxfamily.org/"
SRC_URI="http://download.tuxfamily.org/baller/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="media-libs/libsdl"
RDEPEND="${DEPEND}"
