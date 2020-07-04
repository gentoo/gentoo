# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: server/client remoteosd"
HOMEPAGE="http://vdr.schmirler.de/"
SRC_URI="http://vdr.schmirler.de/remoteosd/${P}.tgz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm ~x86"

DEPEND=">=media-video/vdr-2.4"

PATCHES=( "${FILESDIR}/vdr-2.4_remoteosd-${PV}.patch" )
