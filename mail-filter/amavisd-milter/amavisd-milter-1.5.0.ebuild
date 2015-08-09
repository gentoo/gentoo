# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="sendmail milter for amavisd-new"
HOMEPAGE="http://amavisd-milter.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="|| ( mail-filter/libmilter mail-mta/sendmail )
		mail-filter/amavisd-new"
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" install

	dodoc AUTHORS CHANGES INSTALL README TODO

	newinitd "${FILESDIR}/amavisd-milter.initd" amavisd-milter
	newconfd "${FILESDIR}/amavisd-milter.confd" amavisd-milter
}
