# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: takes screenshots of the current video or tv screen"
HOMEPAGE="https://github.com/jowi24/vdr-screenshot"
SRC_URI="https://github.com/jowi24/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 x86"

DEPEND=">=media-video/vdr-2.0"
RDEPEND="${DEPEND}"
