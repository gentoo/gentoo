# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnustep-2

MY_P=${PN//p/P}.Sources.${PV/_beta/-b}c
DESCRIPTION="a free application for drawing & editing pixel-art images"
HOMEPAGE="https://twilightedge.com/mac/pikopixel/"
SRC_URI="https://twilightedge.com/downloads/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}/${PN//p/P}

LICENSE="AGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=virtual/gnustep-back-0.25.0"
RDEPEND="${DEPEND}"
