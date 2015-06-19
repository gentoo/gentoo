# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-filter/amavisd-milter/amavisd-milter-1.6.0-r1.ebuild,v 1.1 2015/01/16 11:08:17 mschiff Exp $

EAPI="5"

inherit eutils

DESCRIPTION="sendmail milter for amavisd-new"
HOMEPAGE="http://amavisd-milter.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="|| ( mail-filter/libmilter mail-mta/sendmail )
		mail-filter/amavisd-new"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-policybank.patch"
	epatch_user
}

src_install() {
	emake DESTDIR="${D}" install

	dodoc AUTHORS CHANGES INSTALL README TODO

	newinitd "${FILESDIR}/amavisd-milter.initd" amavisd-milter
	newconfd "${FILESDIR}/amavisd-milter.confd" amavisd-milter
}
