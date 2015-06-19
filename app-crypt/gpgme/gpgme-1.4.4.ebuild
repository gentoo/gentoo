# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/gpgme/gpgme-1.4.4.ebuild,v 1.1 2014/07/31 10:00:31 k_f Exp $

EAPI="5"

inherit eutils libtool

DESCRIPTION="GnuPG Made Easy is a library for making GnuPG easier to use"
HOMEPAGE="http://www.gnupg.org/related_software/gpgme"
SRC_URI="mirror://gnupg/gpgme/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2.1"
SLOT="1/11" # subslot = soname major version
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x64-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="common-lisp static-libs"

DEPEND="app-crypt/gnupg
	>=dev-libs/libassuan-2.0.2
	>=dev-libs/libgpg-error-1.4"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.1.8-et_EE.patch
	elibtoolize
}

src_configure() {
	econf \
		--includedir="${EPREFIX}/usr/include/gpgme" \
		--with-gpg="$(readlink -f "${EPREFIX}/usr/bin/gpg")" \
		--with-gpgsm="${EPREFIX}/usr/bin/gpgsm" \
		$(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files

	if ! use common-lisp; then
		rm -fr "${ED}usr/share/common-lisp"
	fi
}
