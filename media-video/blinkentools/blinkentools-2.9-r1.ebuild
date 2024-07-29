# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Provides a set of commandline utilities related to Blinkenlights"
HOMEPAGE="http://blinkenlights.net/project/developer-tools"
SRC_URI="http://blinkenlights.de/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="media-libs/blib
	media-libs/libmng"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"
