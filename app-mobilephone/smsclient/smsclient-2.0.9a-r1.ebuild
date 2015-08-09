# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils user

DESCRIPTION="Utility to send SMS messages to mobile phones and pagers"
HOMEPAGE="http://www.smsclient.org"
SRC_URI="http://www.smsclient.org/download/${PN}-${PV%?}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

pkg_setup() {
	enewgroup dialout
}

src_prepare() {
	epatch "${FILESDIR}/${P}-gentoo.patch"
	epatch "${FILESDIR}/${P}-sender.patch"
	sed -i -e \
		"s:\$(CFLAGS) -o:\$(CFLAGS) \$(LDFLAGS) -o:g" \
		src/client/Makefile
}

src_configure() {
	rm .configured && ./configure
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		AR="$(tc-getAR) rc" \
		RANLIB="$(tc-getRANLIB)" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	emake DESTDIR="${D}" install
	dosym sms_client /usr/bin/smsclient
	dosym sms_address /usr/bin/smsaddress

	diropts -g dialout -m 0770
	keepdir /var/lock/sms
	diropts

	doman docs/sms_client.1
	dodoc AUTHORS Changelog* FAQ README* TODO docs/sms_protocol
}

pkg_config() {
	local MY_LOGFILE="${ROOT}/var/log/smsclient.log"
	[ -f "${MY_LOGFILE}" ] || touch "${MY_LOGFILE}"
	fowners :dialout "${MY_LOGFILE}"
	fperms g+rwx,o-rwx "${MY_LOGFILE}"
}

pkg_postinst() {
	einfo "If you run sms_client as normal user, make sure you are member of dialout group."
}
