# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="Virtual MIDI Piano Keyboard"
HOMEPAGE="https://vmpk.sourceforge.io/"
SRC_URI="https://downloads.sourceforge.net/vmpk/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbus"

BDEPEND="
	app-text/docbook-xsl-stylesheets
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"
DEPEND="
	dev-qt/qtbase:6[gui,network,widgets]
	>=media-sound/drumstick-2.6.0
	x11-libs/libxcb
	dbus? ( dev-qt/qtbase:6[dbus] )
"
RDEPEND="${DEPEND}
	dev-qt/qtsvg:5
"

src_prepare() {
	cmake_src_prepare
}

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
