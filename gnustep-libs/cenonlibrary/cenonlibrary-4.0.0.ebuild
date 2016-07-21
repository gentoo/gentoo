# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
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
