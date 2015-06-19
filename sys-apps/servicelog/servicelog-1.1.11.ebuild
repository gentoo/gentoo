# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/servicelog/servicelog-1.1.11.ebuild,v 1.1 2013/03/01 20:08:57 ranger Exp $

inherit eutils

S=${WORKDIR}/${PN}-${PV}
DESCRIPTION="Provides utilities for logging service-related events"
SRC_URI="mirror://sourceforge/linux-diag/${P}.tar.gz"
HOMEPAGE="http://linux-diag.sourceforge.net/servicelog/"

SLOT="0"
LICENSE="IBM"
KEYWORDS="~ppc ~ppc64"
IUSE=""

DEPEND="sys-libs/libservicelog"

RDEPEND="${DEPEND}
	virtual/logger"

src_unpack() {
	unpack ${A}
}

src_compile() {
	econf
}
src_install () {
	emake install DESTDIR="${D}"
	dodoc ChangeLog
}
