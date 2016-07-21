# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

SRC_URI="ppc? ( mirror://gentoo/${P}.ppc.tar.bz2 )"
DESCRIPTION="vmips cross-development tools"
HOMEPAGE="http://vmips.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ppc"
DEPEND=""
IUSE=""

src_install() {
	mkdir -p ${D}/opt
	mv ${WORKDIR}/mips ${D}/opt
}
