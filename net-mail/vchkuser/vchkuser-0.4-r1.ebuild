# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools qmail

DESCRIPTION="qmail-spp plugin to check recipient existance with vpopmail"
HOMEPAGE="https://github.com/hollow/vchkuser"
SRC_URI="https://github.com/hollow/vchkuser/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug"

DEPEND="
	dev-libs/libpcre
	net-mail/vpopmail
	virtual/libcrypt:=
	|| (
		mail-mta/netqmail[qmail-spp]
		mail-mta/qmail-ldap[qmail-spp]
	)"
RDEPEND="${DEPEND}"

S="${WORKDIR}/hollow-${PN}-8a048f7"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug) \
		--with-vpopuser=vpopmail \
		--with-qmailgroup=nofiles \
		--with-vpopmaildir="${EPREFIX}"/var/vpopmail \
		--with-qmaildir=${QMAIL_HOME}
}

src_install() {
	default

	fowners vpopmail:nofiles "${QMAIL_HOME}"/plugins/vchkuser
	fperms 4750 "${QMAIL_HOME}"/plugins/vchkuser
}
