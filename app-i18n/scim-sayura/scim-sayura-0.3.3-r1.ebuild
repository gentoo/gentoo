# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Sayura Sinhala input method for SCIM"
HOMEPAGE="http://www.sayura.net/im/"
SRC_URI="http://www.sayura.net/im/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND=">=app-i18n/scim-0.99.8"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-gcc45.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf
}

src_install() {
	local HTML_DOCS=( doc/{index.html,style.css} )
	default

	use doc && dodoc doc/sayura.pdf

	# plugin module, no point in .la files
	find "${D}" -type f -name '*.la' -delete || die
}
