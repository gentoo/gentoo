# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-apps/cenon/cenon-3.9.5.ebuild,v 1.4 2012/06/07 15:56:20 xmw Exp $

EAPI=4
inherit gnustep-2

S=${WORKDIR}/${PN/c/C}

DESCRIPTION="Cenon is a vector graphics tool for GNUstep, OpenStep and MacOSX"
HOMEPAGE="http://www.cenon.info/"
SRC_URI="http://www.vhf-group.com/vhf-interservice/download/source/${P/c/C}.tar.bz2"
KEYWORDS="amd64 ppc x86"
SLOT="0"
LICENSE="Cenon"
IUSE=""

DEPEND=""
RDEPEND=">=gnustep-libs/cenonlibrary-3.9.0"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-3.9.4-install.patch
}
