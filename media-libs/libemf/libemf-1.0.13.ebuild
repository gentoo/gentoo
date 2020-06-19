# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Library implementation of ECMA-234 API for the generation of enhanced metafiles"
HOMEPAGE="http://libemf.sourceforge.net/"
SRC_URI="mirror://sourceforge/libemf/${P}.tar.gz"

LICENSE="LGPL-2.1 GPL-2"
SLOT="0"
KEYWORDS="~amd64 -arm ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc static-libs"

src_configure() {
	econf \
		--enable-editing \
		$(use_enable static-libs static)
}

src_install() {
	use doc && HTML_DOCS=( doc/html/. )
	default
	use static-libs || find "${D}" -name '*.la' -type f -delete
}
