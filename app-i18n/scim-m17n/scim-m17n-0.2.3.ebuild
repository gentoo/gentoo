# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="An input module for Smart Common Input Method (SCIM) which uses m17n as backend"
HOMEPAGE="http://www.scim-im.org/projects/imengines"
SRC_URI="mirror://sourceforge/scim/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

RDEPEND=">=app-i18n/scim-1.4
	>=dev-libs/m17n-lib-1.2.0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	default
	# update the 2009 era configure / libtool scripts, which fail with LTO
	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	elog
	elog "To use SCIM with both GTK2 and XIM, you should use the following"
	elog "in your user startup scripts such as .gnomerc or .xinitrc:"
	elog
	elog "LANG='your_language' scim -d"
	elog "export XMODIFIERS=@im=SCIM"
	elog "export GTK_IM_MODULE=\"scim\""
	elog
}
