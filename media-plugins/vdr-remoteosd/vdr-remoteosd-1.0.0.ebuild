# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: server/client remoteosd"
HOMEPAGE="https://vdr.schmirler.de/"
SRC_URI="https://vdr.schmirler.de/remoteosd/${P}.tgz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~arm x86"

DEPEND=">=media-video/vdr-2.0.0"
