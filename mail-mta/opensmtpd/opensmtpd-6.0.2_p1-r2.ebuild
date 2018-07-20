# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit multilib user flag-o-matic eutils pam toolchain-funcs autotools systemd versionator

DESCRIPTION="Lightweight but featured SMTP daemon from OpenBSD"
HOMEPAGE="https://www.opensmtpd.org"
MY_P="${P}"
if [ $(get_last_version_component_index) -eq 4 ]; then
	MY_P="${PN}-$(get_version_component_range 4-)"
fi
SRC_URI="https://www.opensmtpd.org/archives/${MY_P/_}.tar.gz"

LICENSE="ISC BSD BSD-1 BSD-2 BSD-4"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="libressl pam +mta"

DEPEND="!libressl? ( dev-libs/openssl:0 )
		libressl? ( dev-libs/libressl )
		elibc_musl? ( sys-libs/fts-standalone )
		sys-libs/zlib
		pam? ( virtual/pam )
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

S=${WORKDIR}/${MY_P/_}

src_prepare() {
	# Use /run instead of /var/run
	sed -i -e '/pidfile_path/s:_PATH_VARRUN:"/run/":' openbsd-compat/pidfile.c || die
	epatch "${FILESDIR}"/${P}-autoconf.patch
	epatch "${FILESDIR}"/${P}-libressl.patch
	epatch "${FILESDIR}"/${P}-musl.patch
	epatch_user
	eautoreconf
}

src_configure() {
	tc-export AR
	AR="$(which "$AR")" econf \
		--with-table-db \
		--with-user-smtpd=smtpd \
		--with-user-queue=smtpq \
		--with-group-queue=smtpq \
		--with-path-socket=/run \
		--with-path-CAfile=/etc/ssl/certs/ca-certificates.crt \
		--sysconfdir=/etc/opensmtpd \
		$(use_with pam auth-pam)
}

src_install() {
	default
	newinitd "${FILESDIR}"/smtpd.initd smtpd
	systemd_dounit "${FILESDIR}"/smtpd.{service,socket}
	use pam && newpamd "${FILESDIR}"/smtpd.pam smtpd
	dosym /usr/sbin/smtpctl /usr/sbin/makemap
	dosym /usr/sbin/smtpctl /usr/sbin/newaliases
	if use mta ; then
		dodir /usr/sbin
		dosym /usr/sbin/smtpctl /usr/sbin/sendmail
		dosym /usr/sbin/smtpctl /usr/bin/sendmail
		dosym /usr/sbin/smtpctl /usr/$(get_libdir)/sendmail
	fi
}

pkg_preinst() {
	enewgroup smtpd 25
	enewuser smtpd 25 -1 /var/empty smtpd
	enewgroup smtpq 252
	enewuser smtpq 252 -1 /var/empty smtpq
}

pkg_postinst() {
	einfo
	einfo "Plugins for SQLite, MySQL, PostgreSQL, LDAP, socketmaps,"
	einfo "Redis, and many other useful addons and filters are"
	einfo "available in the mail-filter/opensmtpd-extras package."
	einfo
}
