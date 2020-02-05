# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib flag-o-matic eutils pam toolchain-funcs autotools systemd

DESCRIPTION="Lightweight but featured SMTP daemon from OpenBSD"
HOMEPAGE="https://www.opensmtpd.org"
SRC_URI="https://www.opensmtpd.org/archives/${P/_}.tar.gz"

LICENSE="ISC BSD BSD-1 BSD-2 BSD-4"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="libressl pam +mta"

DEPEND="acct-user/smtpd
		acct-user/smtpq
		!libressl? ( dev-libs/openssl:0/1.1 )
		libressl? ( dev-libs/libressl )
		elibc_musl? ( sys-libs/fts-standalone )
		sys-libs/zlib
		pam? ( sys-libs/pam )
		sys-libs/db:=
		dev-libs/libevent
		app-misc/ca-certificates
		net-mail/mailbase
		net-libs/libasr
		!mail-mta/courier
		!mail-mta/esmtp
		!mail-mta/exim
		!mail-mta/mini-qmail
		!mail-mta/msmtp[mta]
		!mail-mta/netqmail
		!mail-mta/nullmailer
		!mail-mta/postfix
		!mail-mta/qmail-ldap
		!mail-mta/sendmail
		!mail-mta/ssmtp[mta]
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${P/_}

src_configure() {
	econf \
		--sysconfdir=/etc/smtpd \
		--with-path-mbox=/var/spool/mail \
		--with-path-empty=/var/empty \
		--with-path-socket=/run \
		--with-path-CAfile=/etc/ssl/certs/ca-certificates.crt \
		--with-user-smtpd=smtpd \
		--with-user-queue=smtpq \
		--with-group-queue=smtpq \
		$(use_with pam auth-pam)
}

src_install() {
	default
	newinitd "${FILESDIR}"/smtpd.initd smtpd
	systemd_dounit "${FILESDIR}"/smtpd.{service,socket}
	use pam && newpamd "${FILESDIR}"/smtpd.pam smtpd
	dosym smtpctl /usr/sbin/makemap
	dosym smtpctl /usr/sbin/newaliases
	if use mta ; then
		dodir /usr/sbin
		dosym smtpctl /usr/sbin/sendmail
		dosym ../sbin/smtpctl /usr/bin/sendmail
		mkdir -p "${ED}"/usr/$(get_libdir)
		ln -s --relative "${ED}"/usr/sbin/smtpctl "${ED}"/usr/$(get_libdir)/sendmail || die
	fi
}

pkg_postinst() {
	einfo
	einfo "Plugins for SQLite, MySQL, PostgreSQL, LDAP, socketmaps,"
	einfo "Redis, and many other useful addons and filters are"
	einfo "available in the mail-filter/opensmtpd-extras package."
	einfo

	ewarn
	ewarn "If you're upgrading from version 6.0, note that the"
	ewarn "configuration syntax has changed, and config files"
	ewarn "now live in /etc/smtpd instead of /etc/opensmtpd."
	ewarn
}
