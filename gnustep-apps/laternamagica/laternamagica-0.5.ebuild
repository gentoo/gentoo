# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnustep-2

MY_P="LaternaMagica-${PV}"
DESCRIPTION="an image viewer and slideshow application"
HOMEPAGE="http://gap.nongnu.org/laternamagica/index.html"
SRC_URI="https://savannah.nongnu.org/download/gap/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/${MY_P}
