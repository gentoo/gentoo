# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit pam toolchain-funcs

DESCRIPTION="Password strength checking library (and PAM module)"
HOMEPAGE="http://www.openwall.com/passwdqc/"
SRC_URI="http://www.openwall.com/${PN}/${P}.tar.gz"

LICENSE="Openwall BSD public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	sys-libs/pam
	virtual/libcrypt:=
"
DEPEND="${RDEPEND}"

QA_FLAGS_IGNORED="
	lib*/security/pam_passwdqc.so
	usr/lib*/libpasswdqc.so.1
"

src_prepare() {
	default

	sed -i -e 's:`uname -s`:Linux:' Makefile || die

	# Ship our own default settings
	cat <<- EOF > "${S}/passwdqc.conf"
		min=disabled,24,11,8,7
		max=72
		passphrase=3
		match=4
		similar=deny
		random=47
		enforce=none
		retry=3
	EOF

}

_emake() {
	emake \
		SHARED_LIBDIR="/usr/$(get_libdir)" \
		DEVEL_LIBDIR="/usr/$(get_libdir)" \
		SECUREDIR="$(getpam_mod_dir)" \
		CONFDIR="/etc/security" \
		CFLAGS="${CFLAGS} ${CPPFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		CC="$(tc-getCC)" \
		LD="$(tc-getCC)" \
		"$@"
}

src_compile() {
	_emake all
}

src_install() {
	_emake DESTDIR="${ED}" install_lib install_pam install_utils
	dodoc README PLATFORMS INTERNALS
}
