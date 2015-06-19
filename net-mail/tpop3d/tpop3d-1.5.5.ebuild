# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/tpop3d/tpop3d-1.5.5.ebuild,v 1.5 2014/12/28 16:37:11 titanofold Exp $

EAPI=4

inherit eutils flag-o-matic autotools

DESCRIPTION="An extensible POP3 server with vmail-sql/MySQL support"
HOMEPAGE="http://savannah.nongnu.org/projects/tpop3d/"
SRC_URI="http://download.savannah.nongnu.org/releases/tpop3d/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="authexternal debug drac flatfile gdbm ldap maildir mbox mysql offensive
	pam passwd perl postgres +sha1 shadow ssl tcpd"

RDEPEND="sha1?		( >=dev-libs/openssl-0.9.6 )
	ssl?		( >=dev-libs/openssl-0.9.6 )
	ldap? 		( >=net-nds/openldap-2.0.7 )
	mysql? 		( virtual/mysql )
	postgres?	( dev-db/postgresql[server] )
	perl?		( >=dev-lang/perl-5.6.1 )
	pam? 		( virtual/pam
				  >=net-mail/mailbase-0.00-r8 )
	tcpd?		( >=sys-apps/tcp-wrappers-7.6 )"

DEPEND="${RDEPEND}
	drac?		( mail-client/drac )"

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.5.4-gold.patch"
	eautoreconf
}

src_configure() {
	local myconf=""
	local noauth=0

	# Various authentication methods
	use authexternal && myconf="${myconf} --enable-auth-other"
	use flatfile	&& myconf="${myconf} --enable-auth-flatfile"
	use gdbm		&& myconf="${myconf} --enable-auth-gdbm"
	use ldap		&& myconf="${myconf} --enable-auth-ldap"
	use mysql		&& myconf="${myconf} --enable-auth-mysql"
	use pam			|| myconf="${myconf} --disable-auth-pam"
	use passwd		&& myconf="${myconf} --enable-auth-passwd"
	use perl		&& myconf="${myconf} --enable-auth-perl"
	use postgres	&& myconf="${myconf} --enable-auth-pgsql"
	use shadow		&& myconf="${myconf} --enable-auth-passwd --enable-shadow-passwords"

	use authexternal || use flatfile || use gdbm || use ldap || use mysql ||
		use	pam || use passwd || use perl || use postgres || use shadow ||
		noauth=1

	if [[ ${noauth} -eq 1 ]]; then
		ewarn "None of tpop3d's authentication mechanism USE flags are set."
		ewarn "As a result tpop3d will be built with /etc/passwd authentication only."
		myconf="${myconf} --enable-auth-passwd"
	fi

	# Other optional features
	use debug		&& myconf="${myconf} --enable-backtrace"
	use maildir		&& myconf="${myconf} --enable-mbox-maildir"
	use mbox		|| myconf="${myconf} --disable-mbox-bsd"
	use offensive	|| myconf="${myconf} --disable-snide-comments"
	use sha1		|| myconf="${myconf} --disable-sha1-passwords"
	use ssl			&& myconf="${myconf} --enable-tls"
	use tcpd		&& myconf="${myconf} --enable-tcp-wrappers"

	# Install mail-client/drac for integration with tpop3d
	use drac		&& myconf="${myconf} --enable-drac"

	econf ${myconf}

	# Causes crash with "stack smashing attack" on connect, because of bug in
	# SSP (bug #115285)
	filter-flags -fstack-protector
}

src_install() {
	emake DESTDIR="${D}" install
	dodir /etc/tpop3d

	if use pam ; then
		dodir /etc/pam.d
		dosym /etc/pam.d/pop3 /etc/pam.d/tpop3d
	fi

	newinitd "${FILESDIR}/${PN}-1.5.4.init" tpop3d
}

pkg_postinst() {
	elog "Read the tpop3d.conf manpage"
	elog "Please create /etc/tpop3d/tpop3d.conf to fit your configuration"
}
