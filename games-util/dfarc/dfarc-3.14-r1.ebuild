# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.2-gtk3"
inherit wxwidgets xdg

DESCRIPTION="Frontend and .dmod installer for GNU FreeDink"
HOMEPAGE="http://www.gnu.org/software/freedink/"
SRC_URI="mirror://gnu/freedink/${P}.tar.gz"

LICENSE="GPL-3 BZIP2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND="
	app-arch/bzip2
	x11-misc/xdg-utils
	x11-libs/wxGTK:${WX_GTK_VER}[X]
"
DEPEND="${RDEPEND}"
BDEPEND="nls? ( dev-util/intltool )"

PATCHES=(
	"${FILESDIR}"/${PN}-3.12-nowindres.patch
	# From OpenSuSE
	"${FILESDIR}"/${P}-wxString.patch
)

src_configure() {
	setup-wxwidgets
	econf \
		$(use_enable nls) \
		--disable-desktopfiles \
		--with-wx-config="${WX_CONFIG}"
}

src_install() {
	default
	dodoc TRANSLATIONS.txt
}
