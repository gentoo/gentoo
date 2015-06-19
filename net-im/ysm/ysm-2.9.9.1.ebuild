# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/ysm/ysm-2.9.9.1.ebuild,v 1.6 2014/05/21 02:45:46 mrueg Exp $

EAPI=5

MY_PV=${PV//./_}

DESCRIPTION="A console ICQ client supporting versions 7/8"
HOMEPAGE="http://ysmv7.sourceforge.net/"
SRC_URI="mirror://sourceforge/ysmv7/${PN}v7_${MY_PV}.tar.bz2"
RESTRICT="mirror"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""
DEPEND=""
RDEPEND=""

S=${WORKDIR}/${PN}v7_${MY_PV}

src_install () {
	dobin src/ysm
	doman src/man/ysm.1
	dodoc README AUTHORS INSTALL
}
