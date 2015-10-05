# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="PKCS#11 helper library"
HOMEPAGE="http://www.opensc-project.org/opensc/wiki/pkcs11-helper"
SRC_URI="mirror://sourceforge/opensc/${PN}/${P}.tar.bz2"

LICENSE="|| ( BSD GPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="doc gnutls libressl nss static-libs"

RDEPEND="
	!libressl? ( >=dev-libs/openssl-0.9.7:0 )
	libressl? ( dev-libs/libressl )
	gnutls? ( >=net-libs/gnutls-1.4.4 )
	nss? ( dev-libs/nss )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( >=app-doc/doxygen-1.4.7 )"

src_configure() {
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		$(use_enable doc) \
		$(use_enable gnutls crypto-engine-gnutls) \
		$(use_enable nss crypto-engine-nss) \
		$(use_enable static-libs static)
}

src_install() {
	default
	find "${ED}" -name '*.la' -exec rm -f {} +
}
