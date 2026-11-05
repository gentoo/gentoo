# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_METHOD="signify"
inherit autotools pam systemd verify-sig

DESCRIPTION="Lightweight but featured SMTP daemon from OpenBSD"
HOMEPAGE="https://www.opensmtpd.org"
SRC_URI="
	https://www.opensmtpd.org/archives/${P/_}.tar.gz
	verify-sig? ( https://www.opensmtpd.org/archives/${P/_}.sum.sig )
"
S="${WORKDIR}/${P/_}"

LICENSE="ISC BSD BSD-1 BSD-2 BSD-4"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
IUSE="berkdb +mta pam split-usr"

DEPEND="
	dev-libs/libbsd
	dev-libs/libevent:=
	dev-libs/openssl:=
	virtual/zlib:=
	virtual/libcrypt:=
	berkdb? ( sys-libs/db:= )
	elibc_musl? ( sys-libs/fts-standalone )
	pam? ( sys-libs/pam )
"
RDEPEND="${DEPEND}
	acct-user/smtpd
	acct-user/smtpq
	app-misc/ca-certificates
	net-mail/mailbase
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
BDEPEND="
	app-alternatives/yacc
	virtual/pkgconfig
	verify-sig? ( sec-keys/signify-keys-opensmtpd )
"

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/signify-keys/${PN}.pub"

QA_CONFIG_IMPL_DECL_SKIP=( closefrom )

DOCS=( {CHANGES,README}.md )

src_unpack() {
	if use verify-sig; then
		# Too many levels of symbolic links
		cp "${DISTDIR}"/${P/_}.{sum.sig,tar.gz} "${WORKDIR}" || die
		verify-sig_verify_signed_checksums \
			${P/_}.sum.sig sha256 ${P/_}.tar.gz
	fi
	default
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--sysconfdir="${EPREFIX}"/etc/smtpd
		--with-path-CAfile="${EPREFIX}"/etc/ssl/certs/ca-certificates.crt
		--with-path-empty="${EPREFIX}"/var/empty
		--with-path-mbox="${EPREFIX}"/var/spool/mail
		--with-path-queue="${EPREFIX}"/var/spool/smtpd
		--with-path-pidfile=/run
		--with-path-socket=/run
		--with-user-smtpd=smtpd
		--with-user-queue=smtpq
		--with-group-queue=smtpq
		--with-libevent="${EPREFIX}"/usr/$(get_libdir)
		--with-libssl="${EPREFIX}"/usr/$(get_libdir)
		--with-libz=="${EPREFIX}"/usr/$(get_libdir)
		$(use_with berkdb table-db)
		$(use_with pam auth-pam)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	newinitd "${FILESDIR}"/smtpd.initd smtpd
	systemd_newunit "${FILESDIR}"/smtpd-r1.service smtpd.service

	use pam && newpamd "${FILESDIR}"/smtpd.pam smtpd

	dosym smtpctl /usr/sbin/makemap
	dosym smtpctl /usr/sbin/newaliases

	if use mta; then
		dodir /usr/sbin
		dosym smtpctl /usr/sbin/sendmail
		# on USE="-split-usr" system sbin and bin are merged
		# so symlink made above will collide with one below
		use split-usr && dosym ../sbin/smtpctl /usr/bin/sendmail
		dodir /usr/$(get_libdir)
		dosym -r /usr/sbin/smtpctl /usr/$(get_libdir)/sendmail
	fi
}
