# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnustep-2

MY_P="TalkSoup-${PV}"

DESCRIPTION="IRC client for GNUstep"
HOMEPAGE="http://gap.nongnu.org/talksoup/"
SRC_URI="http://savannah.nongnu.org/download/gap/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=gnustep-libs/netclasses-1.1.0"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}
