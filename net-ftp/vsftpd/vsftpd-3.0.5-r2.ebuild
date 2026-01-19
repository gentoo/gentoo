# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/vsftpd.asc
inherit systemd toolchain-funcs verify-sig

DESCRIPTION="Very Secure FTP Daemon"
HOMEPAGE="https://security.appspot.com/vsftpd.html"
SRC_URI="
	https://security.appspot.com/downloads/${P}.tar.gz
	verify-sig? ( https://security.appspot.com/downloads/${P}.tar.gz.asc )
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="pam ssl tcpd"

DEPEND="
	>=sys-libs/libcap-2
	pam? ( sys-libs/pam )
	!pam? ( virtual/libcrypt:= )
	ssl? ( dev-libs/openssl:0= )
	tcpd? ( >=sys-apps/tcp-wrappers-7.6 )
"

RDEPEND="${DEPEND}
	net-ftp/ftpbase
"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-vsftpd )"

src_prepare() {
	local PATCHES=(
		"${FILESDIR}"/vsftpd-2.3.2-kerberos.patch
		"${FILESDIR}"/vsftpd-3.0.2-alpha.patch
		"${FILESDIR}"/vsftpd-3.0.3-sparc.patch
		"${FILESDIR}"/vsftpd-3.0.5-seccomp.patch
		"${FILESDIR}"/vsftpd-3.0.5-gcc15.patch
	)
	default
}

define() {
	sed -i -e "/#undef $2/c#define $2${3:+ }$3" "$1" || die
}

undef() {
	sed -i -e "/#define $2/c#undef $2" "$1" || die
}

src_configure() {
	libs=( -lcap )

	if use pam; then
		libs+=( -lpam )
	else
		undef builddefs.h VSF_BUILD_PAM
		libs+=( -lcrypt )
	fi

	if use ssl; then
		define builddefs.h VSF_BUILD_SSL
		libs+=( -lcrypto -lssl )
	fi

	if use tcpd; then
		define builddefs.h VSF_BUILD_TCPWRAPPERS
		libs+=( -lwrap )
	fi

	if use elibc_musl; then
		# musl does not support utmp/wtmp
		# https://bugs.gentoo.org/713952
		undef sysdeputil.c VSF_SYSDEP_HAVE_UTMPX
	fi
}

src_compile() {
	local args=(
		CC="$(tc-getCC)"
		CFLAGS="${CFLAGS}"
		LDFLAGS="${LDFLAGS}"
		LIBS="${libs[*]}"
		LINK=
	)
	emake "${args[@]}"
}

src_install() {
	into /usr
	dosbin vsftpd

	doman vsftpd.conf.5 vsftpd.8

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/vsftpd.logrotate vsftpd

	insinto /etc/xinetd.d
	newins "${FILESDIR}"/vsftpd.xinetd vsftpd

	newinitd "${FILESDIR}"/vsftpd.init-3.0.5 vsftpd

	systemd_newunit "${FILESDIR}"/vsftpd.service-3.0.5 vsftpd.service
	systemd_newunit "${FILESDIR}"/vsftpd_at.service-3.0.5 vsftpd@.service
	systemd_dounit "${FILESDIR}"/vsftpd.socket

	keepdir /usr/share/empty

	dodoc vsftpd.conf
	dodoc -r EXAMPLE SECURITY

	einstalldocs
}

pkg_preinst() {
	if [[ ! -e ${EROOT}/etc/vsftpd.conf && -e ${EROOT}/etc/vsftpd/vsftpd.conf ]]; then
		elog "Moving ${EROOT}/etc/vsftpd/vsftpd.conf to ${EROOT}/etc/vsftpd.conf"
		mv "${EROOT}"/etc/{vsftpd/,}vsftpd.conf || die
	fi
}
