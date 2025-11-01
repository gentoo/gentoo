# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: takes screenshots of the current video or tv screen"
HOMEPAGE="https://github.com/jowi24/vdr-screenshot"
SRC_URI="https://github.com/jowi24/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-video/vdr:="
RDEPEND="${DEPEND}"
