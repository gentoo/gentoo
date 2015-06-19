# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/input-utils/input-utils-0.0.1_pre20050727.ebuild,v 1.3 2008/01/05 00:41:06 robbat2 Exp $

MY_P=input-${PV/0.0.1_pre/}-141704

DESCRIPTION="Small collection of linux input layer utils"
HOMEPAGE="http://dl.bytesex.org/cvs-snapshots/"
SRC_URI="http://dl.bytesex.org/cvs-snapshots/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/input"

src_install() {
	make install bindir="${D}"/usr/bin mandir="${D}"/usr/share/man || die "make install failed"
	dodoc lircd.conf
}
