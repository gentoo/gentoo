# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Network Data Access Protocol client C library"
HOMEPAGE="http://opendap.org/"
SRC_URI="http://opendap.org/pub/OC/source/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc"
# tests need network
RESTRICT="test"

RDEPEND="net-misc/curl"
DEPEND="${RDEPEND}"

src_configure() {
	econf --disable-static
}

src_install() {
	if use doc; then
		dodoc docs/oc*html
		HTML_DOCS=( docs/html/. )
	fi
	default

	# no static archives
	find "${D}" -name '*.la' -delete || die
}
