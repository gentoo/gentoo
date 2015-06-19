# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-apps/gnumail/gnumail-1.2.2.ebuild,v 1.4 2015/04/21 18:57:15 pacho Exp $

EAPI=5
inherit gnustep-2

MY_P=${P/gnum/GNUM}

S=${WORKDIR}/${MY_P}

DESCRIPTION="A fully featured mail application for GNUstep"
HOMEPAGE="http://www.collaboration-world.com/gnumail/"
SRC_URI="http://download.gna.org/gnustep-nonfsf/${MY_P}.tar.gz"
KEYWORDS="amd64 ppc x86 ~x86-fbsd"
LICENSE="GPL-2"
SLOT="0"

IUSE="crypt"
DEPEND=">=gnustep-base/gnustep-gui-0.11.0
	=gnustep-libs/pantomime-1.2*
	gnustep-apps/addresses"
RDEPEND="crypt? ( app-crypt/gnupg )"

src_prepare() {
	sed -i -e 's|GNUMail_GUI_LIBS =|LIBRARIES_DEPEND_UPON +=|' \
		Framework/GNUMail/GNUmakefile || die "as-needed sed failed"
	use crypt || sed -i -e 's|Bundles/PGP||' \
		GNUmakefile || die "PGP bundle sed failed"
}

src_install() {
	gnustep-base_src_install
	dodoc "${S}"/Documentation/*
}
