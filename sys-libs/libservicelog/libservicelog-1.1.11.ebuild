# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils autotools

DESCRIPTION="Provides a library for logging service-related events"
SRC_URI="mirror://sourceforge/linux-diag/${P}.tar.gz"
HOMEPAGE="http://linux-diag.sourceforge.net/servicelog/"

SLOT="0"
LICENSE="IBM"
KEYWORDS="~ppc ~ppc64"
IUSE=""

DEPEND="dev-db/sqlite"

RDEPEND="${DEPEND}
	virtual/logger"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${P}.patch

	eautoreconf
}

src_install () {
	emake install DESTDIR="${D}" || die
	dodoc ChangeLog || die
}
