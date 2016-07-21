# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit pam flag-o-matic

DESCRIPTION="PAM module for authenticating against PKCS#11 tokens"
HOMEPAGE="https://github.com/opensc/pam_p11/wiki"
SRC_URI="mirror://sourceforge/opensc/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE=""

RDEPEND="virtual/pam
		dev-libs/libp11
		dev-libs/openssl"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	# hide all the otherwise-exported symbols that may clash with
	# other software loading the PAM modules (see bug #274924 as an
	# example).
	append-ldflags -Wl,--version-script="${FILESDIR}"/pam_symbols.ver

	econf \
		--disable-static \
		--disable-dependency-tracking \
		--enable-fast-install \
		|| die
}

src_install() {
	dopammod src/.libs/pam_p11_opensc.so
	dopammod src/.libs/pam_p11_openssh.so

	dohtml doc/*.html doc/*.css || die
	dodoc NEWS || die
}
