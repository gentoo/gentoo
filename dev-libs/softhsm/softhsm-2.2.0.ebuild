# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="A software PKCS#11 implementation"
HOMEPAGE="http://www.opendnssec.org/"
SRC_URI="http://www.opendnssec.org/files/source/${P}.tar.gz"

KEYWORDS="~amd64 ~hppa ~x86"
IUSE="debug +migration-tool"
SLOT="2"
LICENSE="BSD"

RDEPEND="
	dev-db/sqlite:3
	dev-libs/botan[threads,-bindist]
	!=dev-libs/softhsm-2.0.0:0
"
DEPEND="${RDEPEND}"

DOCS=( NEWS README.md )

src_configure() {
	econf \
		--disable-static \
		--localstatedir=/var \
		--with-botan="${EPREFIX}/usr/" \
		$(use_with migration-tool migrate) \
		$(use_enable amd64 64bit) \
		$(use debug && echo "--with-loglevel=4")
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete
}
