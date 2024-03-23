# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="An input module for Smart Common Input Method (SCIM) which uses uim as backend"
HOMEPAGE="http://www.scim-im.org/"
SRC_URI="mirror://sourceforge/scim/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="
	>=app-i18n/uim-1.5.0
	>=app-i18n/scim-1.4.0
	dev-libs/libltdl
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-gcc43.patch
	"${FILESDIR}"/${P}-uim-1.5.patch
)

src_prepare() {
	default
	# update the 2007 era configure / libtool scripts, which fail with LTO
	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	default

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
