# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit gnustep-2

MY_P=${PN//p/P}.Sources.${PV/_beta/-b}a
DESCRIPTION="a free application for drawing & editing pixel-art images"
HOMEPAGE="http://twilightedge.com/mac/pikopixel/"
SRC_URI="http://twilightedge.com/downloads/${MY_P}.tar.gz"

LICENSE="AGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=virtual/gnustep-back-0.25.0"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}/${PN//p/P}
