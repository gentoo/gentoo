# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Barcode data matrix reading and writing library"
HOMEPAGE="http://libdmtx.sourceforge.net/"
SRC_URI="https://github.com/dmtx/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="static-libs"

src_prepare() {
	#bug 663346
	sed -i -e "s/-ansi//" test/*/Makefile.am || die

	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static)
}

src_install() {
	default
	find "${ED}" -name '*.la' -exec rm -f {} + || die
}
