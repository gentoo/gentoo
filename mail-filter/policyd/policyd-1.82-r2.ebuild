# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils toolchain-funcs

DESCRIPTION="Policy daemon for postfix and other MTAs"
HOMEPAGE="http://policyd.sf.net/"

# This is not available through SF mirrors
SRC_URI="http://policyd.sourceforge.net/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"
IUSE="libressl"
DEPEND="virtual/mysql
	!libressl? ( dev-libs/openssl:0 )
	libressl? ( dev-libs/libressl )"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-post182.patch"
	epatch "${FILESDIR}/${PN}-makefile.patch"
	sed -i -e "s/gcc/$(tc-getCC)/" Makefile

	ebegin "Applying config patches"
	sed -i -e s:UID=0:UID=65534:g \
	    -e s:GID=0:GID=65534:g \
	    -e s:DAEMON=0:DAEMON=1:g \
	    -e s:DEBUG=3:DEBUG=0:g \
	    -e s:DATABASE_KEEPALIVE=0:DATABASE_KEEPALIVE=1:g \
	    policyd.conf || die "sed failed"
	eend
}

src_compile() {
	emake build || die "emake build failed"
}

src_install() {
	insopts -o root -g nobody -m 0750
	mv cleanup policyd_cleanup
	mv stats policyd_stats

	dosbin policyd policyd_cleanup policyd_stats

	insopts -o root -g nobody -m 0640
	insinto /etc
	doins policyd.conf

	insopts -o root -g nobody -m 0700
	exeinto /etc/cron.hourly
	newexe "${FILESDIR}/${PN}-cleanup.cron" ${PN}-cleanup.cron

	dodoc ChangeLog DATABASE.mysql README doc/support.txt

	newinitd "${FILESDIR}/${PN}.rc" ${PN}
	newconfd "${FILESDIR}/${PN}.confd" ${PN}
}

pkg_postinst() {
	elog "You will need to create the database using the script DATABASE.mysql"
	elog "in /usr/share/doc/${PF}/"
	elog "Read the mysql section of the README.txt for details."
	elog
	elog "To use policyd with postfix, update your /etc/postfix/main.cf file by adding"
	elog "  check_policy_service inet:127.0.0.1:10031"
	elog "to your smtpd_recipient_restrictions line, or similar."
	elog
	elog "Also remember to start the daemon at boot:"
	elog "  rc-update add policyd default"
	elog
	elog "Read the documentation for more info."
}
