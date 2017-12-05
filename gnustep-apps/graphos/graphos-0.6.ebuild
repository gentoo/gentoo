# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnustep-2

MY_P=${PN/g/G}-${PV}
DESCRIPTION="vector drawing application centered around bezier paths"
HOMEPAGE="http://gap.nongnu.org/graphos/index.html"
SRC_URI="https://savannah.nongnu.org/download/gap/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

S=${WORKDIR}/${MY_P}
