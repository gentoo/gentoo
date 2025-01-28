# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Virtual MIDI Piano Keyboard"
HOMEPAGE="https://vmpk.sourceforge.io/"
SRC_URI="https://downloads.sourceforge.net/vmpk/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="dbus"

DEPEND="
	dev-qt/qtbase:6[dbus?,gui,network,widgets]
	>=media-sound/drumstick-2.10.0
	x11-libs/libxcb
"
RDEPEND="${DEPEND}
	dev-qt/qtsvg:6
"
BDEPEND="
	app-text/docbook-xsl-stylesheets
	dev-qt/qttools:6[linguist]
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=(
		-DENABLE_DBUS=$(usex dbus)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	dodir /usr/share/doc/${PF}/html
	mv "${D}"/usr/share/vmpk/*.html "${D}"/usr/share/doc/${PF}/html/ || die
}
