# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/xmlsec/xmlsec-1.2.18.ebuild,v 1.5 2014/03/01 22:21:39 mgorny Exp $

EAPI="4"

DESCRIPTION="Command line tool for signing, verifying, encrypting and decrypting XML"
HOMEPAGE="http://www.aleksey.com/xmlsec"
SRC_URI="http://www.aleksey.com/xmlsec/download/${PN}1-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE="gcrypt gnutls nss +openssl"
REQUIRED_USE="|| ( gcrypt gnutls nss openssl ) gnutls? ( gcrypt )"

RDEPEND=">=dev-libs/libxml2-2.7.4
	>=dev-libs/libxslt-1.0.20
	gcrypt? ( >=dev-libs/libgcrypt-1.4.0:0 )
	gnutls? ( >=net-libs/gnutls-2.8.0 )
	nss? (
		>=dev-libs/nspr-4.4.1
		>=dev-libs/nss-3.9
	)
	openssl? ( >=dev-libs/openssl-0.9.7 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${PN}1-${PV}"

#src_prepare() {
#	eautoreconf
#	append-cppflags '-DLTDL_OBJDIR=\".libs\"' '-DLTDL_SHLIB_EXT=\".so\"'
#}

src_configure() {
	econf \
		$(use_with gcrypt gcrypt "") \
		$(use_with gnutls gnutls "") \
		$(use_with nss nspr "") \
		$(use_with nss nss "") \
		$(use_enable openssl aes) \
		$(use_with openssl openssl "") \
		--enable-pkgconfig \
		--enable-xkms \
		--with-html-dir=/usr/share/doc/${PF}
}

src_test() {
	emake TMPFOLDER="${T}" check || die "emake check failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	find "${ED}" -name "*.la" -print0 | xargs -0 rm -f
	dodoc AUTHORS README NEWS || die "dodoc failed"
}
