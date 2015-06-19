# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnustep-libs/cenonlibrary/cenonlibrary-3.9.4.ebuild,v 1.4 2012/06/07 15:06:00 xmw Exp $

EAPI=4
inherit gnustep-2

S=${WORKDIR}/Cenon

DESCRIPTION="Default library required to run Cenon"
HOMEPAGE="http://www.cenon.info/"
SRC_URI="http://www.vhf-group.com/vhf-interservice/download/source/CenonLibrary-${PV}-1.tar.bz2"
KEYWORDS="amd64 ppc x86"
SLOT="0"
LICENSE="Cenon"
IUSE=""

src_compile() {
	echo "nothing to compile"
}

src_install() {
	egnustep_env
	dodir ${GNUSTEP_SYSTEM_LIBRARY}
	cp -pPR "${S}" "${D}"${GNUSTEP_SYSTEM_LIBRARY}
}
