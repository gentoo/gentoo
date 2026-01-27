# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature

DESCRIPTION="Japanese input method Anthy IMEngine for SCIM"
HOMEPAGE="https://github.com/scim-im/scim-anthy/"
SRC_URI="https://github.com/scim-im/scim-anthy/releases/download/RELEASE_${PV//./_}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~sparc ~x86"
IUSE="+gtk3 nls"

DEPEND="
	app-accessibility/at-spi2-core:2
	app-i18n/anthy-unicode
	>=app-i18n/scim-1.2[gtk3=]
	dev-libs/glib:2
	media-libs/harfbuzz:=
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/pango
	!gtk3? ( x11-libs/gtk+:2 )
	gtk3? ( x11-libs/gtk+:3[X] )
	nls? ( virtual/libintl )
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.0-fix_clang.patch
)

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
