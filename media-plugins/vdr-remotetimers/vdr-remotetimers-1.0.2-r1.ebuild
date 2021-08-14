# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: edit timers on remote vdr instances"
HOMEPAGE="https://vdr.schmirler.de/"
SRC_URI="https://vdr.schmirler.de/${PN#vdr-}/${P}.tgz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~arm x86"

DEPEND="~media-video/vdr-2.2.0"
