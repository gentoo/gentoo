# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Barcode data matrix reading and writing library"
HOMEPAGE="http://libdmtx.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/${PN}/${PN}/${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc ppc64 x86"
IUSE="static-libs"

DEPEND=""
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		$(use_enable static-libs static)
}

src_install() {
	default
	find "${ED}" -name '*.la' -exec rm -f {} +
}
