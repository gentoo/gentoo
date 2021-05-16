# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Sayura Sinhala input method for SCIM"
HOMEPAGE="http://www.sayura.net/im/"
SRC_URI="http://www.sayura.net/im/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND=">=app-i18n/scim-0.99.8"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/scim-sayura-0.3.3-gcc45.patch )

src_configure() {
	econf --disable-static
}

src_install() {
	HTML_DOCS=( doc/{index.html,style.css} )
	default

	use doc && dodoc doc/sayura.pdf

	# plugin module, no point in .la files
	find "${D}" -name '*.la' -delete || die
}
