# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/vchkuser/vchkuser-0.3.3.ebuild,v 1.2 2010/10/04 12:40:02 hollow Exp $

EAPI="2"

inherit autotools qmail

DESCRIPTION="qmail-spp plugin to check recipient existance with vpopmail"
HOMEPAGE="http://github.com/hollow/vchkuser"
SRC_URI="http://bb.xnull.de/projects/vchkuser/dist/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="net-mail/vpopmail
	|| ( mail-mta/netqmail[qmail-spp] mail-mta/qmail-ldap[qmail-spp] )"
RDEPEND=""

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug) \
		--with-vpopuser=vpopmail \
		--with-qmailgroup=nofiles \
		--with-vpopmaildir=/var/vpopmail \
		--with-qmaildir=${QMAIL_HOME}
}

src_install() {
	emake DESTDIR="${D}" install || die "emake failed"
	fowners vpopmail:nofiles "${QMAIL_HOME}"/plugins/vchkuser
	fperms 4750 "${QMAIL_HOME}"/plugins/vchkuser
}
