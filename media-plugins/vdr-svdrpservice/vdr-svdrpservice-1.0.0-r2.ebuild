# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: offers SVDRP connections as a service to other plugins"
HOMEPAGE="https://vdr.schmirler.de/"
SRC_URI="https://vdr.schmirler.de/svdrpservice/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

DEPEND="media-video/vdr:="
RDEPEND="${DEPEND}"
