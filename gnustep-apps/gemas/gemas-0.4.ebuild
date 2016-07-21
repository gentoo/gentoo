# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils gnustep-2

MY_P=${P/g/G}
DESCRIPTION="a simple code editor for GNUstep"
HOMEPAGE="http://wiki.gnustep.org/index.php/Gemas.app"
SRC_URI="http://download.gna.org/gnustep-nonfsf/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="projectcenter"

DEPEND=">=gnustep-libs/highlighterkit-0.1.2
	>=virtual/gnustep-back-0.22.0
	projectcenter? ( gnustep-apps/projectcenter )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-bundle_makefile.patch
}

src_compile() {
	gnustep-base_src_compile
	if use projectcenter;
	then
		cd Bundle/Gemas || die "compile cd failed"
		egnustep_make
	fi
}

src_install() {
	gnustep-base_src_install
	if use projectcenter;
	then
		cd Bundle/Gemas || die "install cd failed"
		egnustep_install
	fi
}
