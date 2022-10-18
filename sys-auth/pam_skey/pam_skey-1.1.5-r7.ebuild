# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools readme.gentoo-r1

DESCRIPTION="PAM interface for the S/Key authentication system"
HOMEPAGE="https://web.archive.org/web/20041223070454/http://kreator.esa.fer.hr/projects/pam_skey/"
SRC_URI="https://dkorunic.net/tarballs/${P}.tar.gz
	https://dev.gentoo.org/~ulm/distfiles/${P}-patches-8.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=sys-libs/pam-0.78-r3
	>=sys-auth/skey-1.1.5-r4"
DEPEND="${RDEPEND}"

PATCHES=("${WORKDIR}/patch")
DOCS="README INSTALL"

src_prepare() {
	default

	cd autoconf || die
	mv configure.{in,ac} || die
	eautoconf
	eautoheader
	mv configure defs.h.in .. || die
}

src_configure() {
	econf --libdir="/$(get_libdir)" CFLAGS="${CFLAGS} -fPIC"
}

src_install() {
	default

	local DOC_CONTENTS="To use the pam_skey module, you need to
	configure PAM by adding a line like:
	\n\nauth [success=done ignore=ignore auth_err=die default=bad] pam_skey.so\n
	\nto an appropriate place in the /etc/pam.d/system-login file.
	Consult the README and INSTALL files in /usr/share/doc/${PF}
	for detailed instructions.
	\n\nPlease note that calling this module from unprivileged
	applications, e.g. screensavers, is not supported.
	\n\nError checking has become stricter in pam_skey-1.1.5-r4;
	errors returned from the underlying skey library when accessing
	the S/Key data base will no longer be ignored.
	Make sure that your PAM configuration is correct."
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
