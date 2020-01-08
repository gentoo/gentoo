# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit pam eutils toolchain-funcs multilib

DESCRIPTION="Password strength checking library (and PAM module)"
HOMEPAGE="http://www.openwall.com/passwdqc/"
SRC_URI="http://www.openwall.com/${PN}/${P}.tar.gz"

LICENSE="Openwall BSD public-domain"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux"
IUSE="pam utils"

RDEPEND="
	pam? (
		sys-libs/pam
		!<sys-auth/pam_passwdqc-1.3.0
	)"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.3.0-build.patch
	sed -i \
		-e 's:`uname -s`:Linux:' \
		Makefile || die
	# See if the system has a shadow.h. #554504
	echo '#include <shadow.h>' > "${T}"/test.c
	if ! $(tc-getCPP) ${CPPFLAGS} "${T}"/test.c >& /dev/null ; then
		sed -i -e 's:-DHAVE_SHADOW::' Makefile || die
	fi
}

_emake() {
	emake \
		LIBDIR="$(get_libdir)" \
		CFLAGS="${CFLAGS} ${CPPFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		CC="$(tc-getCC)" \
		LD="$(tc-getCC)" \
		"$@"
}

src_compile() {
	# The use of wrapped targets defeats the Makefile dep tracking.
	# Build all the targets explicitly after the library.
	_emake lib
	if use pam || use utils ; then
		_emake $(usev pam) $(usev utils)
	fi
}

src_install() {
	_emake \
		DESTDIR="${ED}" \
		install_lib $(usex pam install_pam '') $(usex utils install_utils '')
	dodoc README PLATFORMS INTERNALS
}

pkg_postinst() {
	if use pam ; then
		elog "To activate pam_passwdqc use pam_passwdqc.so instead"
		elog "of pam_cracklib.so in /etc/pam.d/system-auth."
		elog "Also, if you want to change the parameters, read up"
		elog "on the pam_passwdqc(8) man page."
	fi
}
