# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="esmtp is a user configurable relay-only Mail Transfer Agent (MTA) with a sendmail compatible syntax"
HOMEPAGE="http://esmtp.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="libressl"

CDEPEND="
	net-libs/libesmtp
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:= )
"
RDEPEND="${CDEPEND}
	!mail-mta/courier
	!mail-mta/exim
	!mail-mta/mini-qmail
	!mail-mta/msmtp
	!mail-mta/netqmail
	!mail-mta/nullmailer
	!mail-mta/postfix
	!mail-mta/qmail-ldap
	!mail-mta/sendmail
	!mail-mta/ssmtp
	!mail-mta/opensmtpd
"
DEPEND="${CDEPEND}
	sys-devel/flex
"

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS README TODO sample.esmtprc
}

pkg_postinst() {
	elog "A sample esmtprc file has been installed in /usr/share/doc/${P}"
}
