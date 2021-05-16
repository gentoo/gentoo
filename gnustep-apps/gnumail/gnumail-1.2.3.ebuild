# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnustep-2

MY_P=${P/gnum/GNUM}

S=${WORKDIR}/${MY_P}

DESCRIPTION="A fully featured mail application for GNUstep"
HOMEPAGE="http://www.nongnu.org/gnustep-nonfsf/gnumail/"
SRC_URI="mirror://nongnu/gnustep-nonfsf/${MY_P}.tar.gz"
KEYWORDS="~amd64 ~ppc ~x86"
LICENSE="GPL-2"
SLOT="0"

IUSE="crypt"
DEPEND=">=gnustep-base/gnustep-gui-0.11.0
	=gnustep-libs/pantomime-1.2*
	gnustep-apps/addresses"
RDEPEND="crypt? ( app-crypt/gnupg )"

src_prepare() {
	use crypt || sed -i -e 's|Bundles/PGP||' GNUmakefile || die

	default
}

src_install() {
	gnustep-base_src_install
	dodoc "${S}"/Documentation/*
}
