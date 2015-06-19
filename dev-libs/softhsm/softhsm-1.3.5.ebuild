# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/softhsm/softhsm-1.3.5.ebuild,v 1.1 2013/11/10 09:59:47 mschiff Exp $

EAPI=5

DESCRIPTION="A software PKCS#11 implementation"
HOMEPAGE="http://www.opendnssec.org/"
SRC_URI="http://www.opendnssec.org/files/source/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
IUSE="debug"
SLOT="0"
LICENSE="BSD"

RDEPEND="
	dev-db/sqlite:3
	>=dev-libs/botan-1.10.1[threads]
"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS NEWS README )

src_configure() {
	econf \
		--disable-static \
		--localstatedir=/var \
		--with-botan="${EPREFIX}/usr/" \
		$(use_enable amd64 64bit) \
		$(use debug && echo "--with-loglevel=4")
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete
}
