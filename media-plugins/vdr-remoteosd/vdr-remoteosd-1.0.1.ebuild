# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: server/client remoteosd"
HOMEPAGE="https://github.com/vdr-projects/vdr-plugin-remoteosd https://vdr.schmirler.de/"
SRC_URI="https://github.com/vdr-projects/vdr-plugin-remoteosd/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/vdr-plugin-remoteosd-${PV}"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm x86"

DEPEND=">=media-video/vdr-2.4"
