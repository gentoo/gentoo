# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit base flag-o-matic pam toolchain-funcs

DESCRIPTION="A Unix Web Authenticator"
HOMEPAGE="https://github.com/phokz/pwauth/tree/master/pwauth"
SRC_URI="https://pwauth.googlecode.com/files/${P}.tar.gz"

LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="faillog pam ignore-case domain-aware"

DEPEND="pam? ( virtual/pam )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-config.patch"
	"${FILESDIR}/${P}-makefile.patch"
	"${FILESDIR}/${PN}-strchr.patch"
)

pkg_setup() {
	einfo "You can configure various build time options with ENV variables:"
	einfo
	einfo "    PWAUTH_FAILLOG      Path to logfile for login failures"
	einfo "                        (default: /var/log/pwauth.log)"
	einfo "    PWAUTH_SERVERUIDS   Comma seperated list of UIDs allowed to run pwauth"
	einfo "                        (default: 81)"
	einfo "    PWAUTH_MINUID       Minimum UID for which authentication will succeed"
	einfo "                        (default: 1000)"
	einfo

	PWAUTH_FAILLOG="${PWAUTH_FAILLOG:-/var/log/pwauth.log}"
	PWAUTH_SERVERUIDS="${PWAUTH_SERVERUIDS:-81}"
	PWAUTH_MINUID="${PWAUTH_MINUID:-1000}"

	append-cflags "-DSERVER_UIDS=${PWAUTH_SERVERUIDS}"
	append-cflags "-DMIN_UNIX_UID=${PWAUTH_MINUID}"

	if use faillog; then
		append-cflags -DFAILLOG_PWAUTH
		append-cflags "-DPATH_FAILLOG=\"\\\"${PWAUTH_FAILLOG}\\\"\""
	fi

	if use pam; then
		append-cflags -DPAM
		append-libs pam
	else
		append-cflags -DSHADOW_SUN
		append-libs crypt
	fi

	use ignore-case && append-cflags -DIGNORE_CASE
	use domain-aware && append-cflags -DOMAIN_AWARE
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	dosbin pwauth unixgroup
	fperms 4755 /usr/sbin/pwauth

	use pam && newpamd "${FILESDIR}"/pwauth.pam-include pwauth

	dodoc CHANGES FORM_AUTH INSTALL README
}
