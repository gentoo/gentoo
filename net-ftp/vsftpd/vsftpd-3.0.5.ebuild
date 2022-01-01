# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd toolchain-funcs

DESCRIPTION="Very Secure FTP Daemon"
HOMEPAGE="https://security.appspot.com/vsftpd.html"
SRC_URI="https://security.appspot.com/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="pam ssl tcpd"

BDEPEND="
	virtual/pkgconfig
"

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

src_prepare() {
	local PATCHES=(
		"${FILESDIR}"/vsftpd-2.3.2-kerberos.patch
		"${FILESDIR}"/vsftpd-3.0.2-alpha.patch
		"${FILESDIR}"/vsftpd-3.0.3-sparc.patch
		"${FILESDIR}"/vsftpd-3.0.5-fix-link-command.patch
	)
	default
}

define() {
	sed -i -e "/#undef $1/c#define $1" "${S}"/builddefs.h || die
}

undef() {
	sed -i -e "/#define $1/c#undef $1" "${S}"/builddefs.h || die
}

src_configure() {
	cflags=()
	libs=()

	local PKG_CONFIG=$(tc-getPKG_CONFIG)

	cflags+=( $(${PKG_CONFIG} --cflags libcap) ) || die
	libs+=( $(${PKG_CONFIG} --libs libcap) ) || die

	if use pam; then
		libs+=( -lpam )
	else
		undef VSF_BUILD_PAM
		libs+=( -lcrypt )
	fi

	if use ssl; then
		define VSF_BUILD_SSL
		cflags+=( $(${PKG_CONFIG} --cflags libcrypto libssl) ) || die
		libs+=( $(${PKG_CONFIG} --libs libcrypto libssl) ) || die
	fi

	if use tcpd; then
		define VSF_BUILD_TCPWRAPPERS
		libs+=( -lwrap )
	fi
}

src_compile() {
	local args=(
		CC="$(tc-getCC)"
		CFLAGS="${CFLAGS} ${cflags[*]}"
		LDFLAGS="${CFLAGS} ${LDFLAGS}"
		LIBS="${libs[*]}"
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
