# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Command line tool for signing, verifying, encrypting and decrypting XML"
HOMEPAGE="https://www.aleksey.com/xmlsec"
SRC_URI="https://www.aleksey.com/xmlsec/download/${PN}1-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc ~ppc64 ~sparc x86"
IUSE="doc gcrypt gnutls libressl nss +openssl static-libs"
REQUIRED_USE="|| ( gcrypt gnutls nss openssl )
	gnutls? ( gcrypt )"

RDEPEND=">=dev-libs/libxml2-2.7.4
	>=dev-libs/libxslt-1.0.20
	gcrypt? ( >=dev-libs/libgcrypt-1.4.0:0 )
	gnutls? ( >=net-libs/gnutls-2.8.0 )
	nss? (
		>=dev-libs/nspr-4.4.1
		>=dev-libs/nss-3.9
	)
	openssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${PN}1-${PV}"

src_prepare() {
	default
	# conditionally install extra documentation
	if ! use doc ; then
		sed -i '/^SUBDIRS/s/docs//' Makefile.am || die
		eautoreconf
	fi
}

src_configure() {
	econf \
		--enable-pkgconfig \
		--with-html-dir=/usr/share/doc/${PF}/html \
		$(use_enable static-libs static) \
		$(use_with gcrypt gcrypt "") \
		$(use_with gnutls gnutls "") \
		$(use_with nss nspr "") \
		$(use_with nss nss "") \
		$(use_with openssl openssl "") \
		$(use_enable openssl aes)
}

src_test() {
	emake TMPFOLDER="${T}" check
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
