# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VERIFY_SIG_METHOD="signify"
inherit pam systemd verify-sig

DESCRIPTION="Lightweight but featured SMTP daemon from OpenBSD"
HOMEPAGE="https://www.opensmtpd.org"
SRC_URI="https://www.opensmtpd.org/archives/${P/_}.tar.gz
	verify-sig? ( https://www.opensmtpd.org/archives/${P/_}.sum.sig	)"
VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}/usr/share/signify-keys/opensmtpd-20181026.pub"

LICENSE="ISC BSD BSD-1 BSD-2 BSD-4"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc64 ~riscv x86"
IUSE="berkdb +mta pam split-usr"

DEPEND="
	acct-user/smtpd
	acct-user/smtpq
	>=dev-libs/openssl-1.1:0=
	elibc_musl? ( sys-libs/fts-standalone )
	sys-libs/zlib
	pam? ( sys-libs/pam )
	berkdb? ( sys-libs/db:= )
	dev-libs/libevent:=
	app-misc/ca-certificates
	net-mail/mailbase
	net-libs/libasr
	virtual/libcrypt:=
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
BDEPEND="verify-sig? ( sec-keys/signify-keys-opensmtpd )"

S=${WORKDIR}/${P/_}

src_unpack() {
	if use verify-sig; then
		# Too many levels of symbolic links
		cp "${DISTDIR}"/${P/_}.{sum.sig,tar.gz} "${WORKDIR}" || die
		verify-sig_verify_signed_checksums \
			${P/_}.sum.sig sha256 ${P/_}.tar.gz
	fi

	default
}

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
		$(use_with pam auth-pam) \
		$(use_with berkdb table-db)
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
		# on USE="-split-usr" system sbin and bin are merged
		# so symlink made above will collide with one below
		use split-usr && dosym ../sbin/smtpctl /usr/bin/sendmail
		mkdir -p "${ED}"/usr/$(get_libdir) || die
		ln -s --relative "${ED}"/usr/sbin/smtpctl "${ED}"/usr/$(get_libdir)/sendmail || die
	fi
}
