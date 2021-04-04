# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WX_GTK_VER="3.0"
inherit wxwidgets

DESCRIPTION="flashtool for the multi purpose programming adapter usbprog"
HOMEPAGE="http://www.embedded-projects.net/index.php?page_id=215"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gui"

RDEPEND="
	dev-libs/libxml2
	net-misc/curl
	sys-libs/readline:0=
	virtual/libusb:0
	gui? ( x11-libs/wxGTK:${WX_GTK_VER} )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${P}-wx3.0.patch )

src_configure() {
	use gui && setup-wxwidgets unicode
	econf \
		--disable-static \
		$(use_enable gui)
}

src_install() {
	default

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}
