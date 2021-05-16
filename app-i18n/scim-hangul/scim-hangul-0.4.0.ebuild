# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Hangul IMEngine for SCIM ported from imhangul"
HOMEPAGE="http://www.scim-im.org/"
SRC_URI="mirror://sourceforge/scim/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="nls"

RDEPEND="
	>=app-i18n/scim-0.99.8
	>=app-i18n/libhangul-0.0.4
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.3.2+gcc-4.3.patch
	"${FILESDIR}"/${PN}-0.3.2+gcc-4.7.patch
	"${FILESDIR}"/${PN}-0.4.0+gtk.patch
)

src_configure() {
	econf \
		--disable-skim-support \
		$(use_enable nls)
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
