# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit vdr-plugin-2

GITHASH="02d155ebe1a7d27aea3a4c1d99d2f9bf91b619a6"

DESCRIPTION="VDR Plugin: Provides an easy way of connecting possible streaming clients to VDR"
HOMEPAGE="https://github.com/vdr-projects/vdr-plugin-ffnetdev"
SRC_URI="https://github.com/vdr-projects/vdr-plugin-ffnetdev/archive/${GITHASH}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/vdr-plugin-ffnetdev-${GITHASH}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-video/vdr"
RDEPEND="${DEPEND}"
