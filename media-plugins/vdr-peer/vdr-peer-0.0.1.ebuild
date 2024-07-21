# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: peer-to-peer between multiple VDRs"
HOMEPAGE="https://vdr.schmirler.de/"
SRC_URI="https://vdr.schmirler.de/peer/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-video/vdr"
RDEPEND="${DEPEND}"
