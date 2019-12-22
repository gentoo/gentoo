# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnustep-2

S=${WORKDIR}/${P/t/T}

DESCRIPTION="A terminal emulator for GNUstep"
HOMEPAGE="http://www.nongnu.org/terminal/"
SRC_URI="https://savannah.nongnu.org/download/gap/${P/t/T}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86"
SLOT="0"
IUSE=""
