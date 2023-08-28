# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools pam systemd

DESCRIPTION="Lightweight but featured SMTP daemon from OpenBSD"
HOMEPAGE="https://www.opensmtpd.org"
SRC_URI="https://www.opensmtpd.org/archives/${P/_}.tar.gz"
S="${WORKDIR}/${P/_}"

LICENSE="ISC BSD BSD-1 BSD-2 BSD-4"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
IUSE="berkdb +mta pam split-usr"

RDEPEND="
	acct-user/smtpd
	acct-user/smtpq
	app-misc/ca-certificates
	dev-libs/libbsd
	dev-libs/libevent:=
	dev-libs/openssl:=
	net-libs/libasr
	net-mail/mailbase
	sys-libs/zlib
	virtual/libcrypt:=
	berkdb? ( sys-libs/db:= )
	elibc_musl? ( sys-libs/fts-standalone )
	pam? ( sys-libs/pam )
	!mail-client/mailx-support
	!mail-mta/courier
	!mail-mta/esmtp
	!mail-mta/exim
	!mail-mta/msmtp[mta]
	!mail-mta/netqmail
	!mail-mta/nullmailer
	!mail-mta/postfix
	!mail-mta/sendmail
	!mail-mta/ssmtp[mta]
"
DEPEND="${RDEPEND}"
BDEPEND="app-alternatives/yacc"

QA_CONFIG_IMPL_DECL_SKIP=(
	# LibreSSL link check
	SSLeay_add_all_algorithms
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--sysconfdir="${EPREFIX}"/etc/smtpd \
		--with-path-mbox="${EPREFIX}"/var/spool/mail \
		--with-path-empty="${EPREFIX}"/var/empty \
		--with-path-socket=/run \
		--with-path-CAfile="${EPREFIX}"/etc/ssl/certs/ca-certificates.crt \
		--with-user-smtpd=smtpd \
		--with-user-queue=smtpq \
		--with-group-queue=smtpq \
		--with-libevent="${EPREFIX}"/usr/$(get_libdir) \
		--with-libssl="${EPREFIX}"/usr/$(get_libdir) \
		$(use_with pam auth-pam) \
		$(use_with berkdb table-db)
}

src_install() {
	default

	newinitd "${FILESDIR}"/smtpd.initd smtpd
	systemd_newunit "${FILESDIR}"/smtpd-r1.service smtpd.service

	use pam && newpamd "${FILESDIR}"/smtpd.pam smtpd

	dosym smtpctl /usr/sbin/makemap
	dosym smtpctl /usr/sbin/newaliases

	if use mta ; then
		dodir /usr/sbin
		dosym smtpctl /usr/sbin/sendmail
		# on USE="-split-usr" system sbin and bin are merged
		# so symlink made above will collide with one below
		use split-usr && dosym ../sbin/smtpctl /usr/bin/sendmail
		dodir /usr/$(get_libdir)
		dosym -r /usr/sbin/smtpctl /usr/$(get_libdir)/sendmail
	fi
}
