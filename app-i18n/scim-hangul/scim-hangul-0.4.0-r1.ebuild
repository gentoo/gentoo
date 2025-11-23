# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Hangul IMEngine for SCIM ported from imhangul"
HOMEPAGE="http://www.scim-im.org/"
SRC_URI="https://downloads.sourceforge.net/scim/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls"

DEPEND="
	app-accessibility/at-spi2-core:2
	>=app-i18n/scim-0.99.8
	>=app-i18n/libhangul-0.0.4:=
	dev-libs/glib:2
	media-libs/fontconfig
	media-libs/freetype
	media-libs/harfbuzz:=
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	x11-libs/pango
	nls? ( virtual/libintl )
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.3.2+gcc-4.3.patch
	"${FILESDIR}"/${PN}-0.3.2+gcc-4.7.patch
	"${FILESDIR}"/${PN}-0.4.0+gtk.patch
)

src_configure() {
	local myeconfargs=(
		--without-included-libltdl
		--disable-skim-support
		$(use_enable nls)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	dodoc ChangeLog*

	# plugin module, no point in .la files
	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	elog
	elog "To use SCIM with both GTK2 and XIM, you should use the following"
	elog "in your user startup scripts such as .gnomerc or .xinitrc:"
	elog
	elog "LANG='your_language' scim -d"
	elog "export XMODIFIERS=@im=SCIM"
	elog
}
