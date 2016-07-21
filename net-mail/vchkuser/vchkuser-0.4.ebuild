# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

inherit autotools qmail

DESCRIPTION="qmail-spp plugin to check recipient existance with vpopmail"
HOMEPAGE="https://github.com/hollow/vchkuser"
SRC_URI="https://github.com/hollow/vchkuser/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND="net-mail/vpopmail
	|| ( mail-mta/netqmail[qmail-spp] mail-mta/qmail-ldap[qmail-spp] )"
RDEPEND=""

S="${WORKDIR}/hollow-${PN}-8a048f7"

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
