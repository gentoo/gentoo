# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools optfeature

DESCRIPTION="Japanese input method Anthy IMEngine for SCIM"
HOMEPAGE="https://github.com/scim-im/scim-anthy/"
HASH_COMMIT="83f5f2b1eedb0bba584faeb8b03271c924ee8816"
SRC_URI="https://github.com/scim-im/scim-anthy/archive/${HASH_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${HASH_COMMIT}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~sparc ~x86"
IUSE="+gtk3 nls"

DEPEND="
	app-i18n/anthy-unicode
	>=app-i18n/scim-1.2[gtk3=]
	!gtk3? ( x11-libs/gtk+:2 )
	gtk3? ( x11-libs/gtk+:3[X] )
	nls? ( virtual/libintl )
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable nls)
}

src_install() {
	default

	# plugin module, no point in .la files
	find "${D}" -type f -name '*.la' -delete || die
}

pkg_postinst() {
	optfeature "a dictionary management tool" app-dicts/kasumi
}
