# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: Show a history of the last OSD message"
HOMEPAGE="https://github.com/jowi24/vdr-mlist"
SRC_URI="https://github.com/jowi24/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="amd64 x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=">=media-video/vdr-2.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}"
