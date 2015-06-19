# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/servicelog/servicelog-1.1.13.ebuild,v 1.1 2015/06/04 05:54:16 jer Exp $

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
