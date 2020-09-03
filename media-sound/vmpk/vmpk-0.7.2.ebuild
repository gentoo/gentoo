# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg

DESCRIPTION="Virtual MIDI Piano Keyboard"
HOMEPAGE="http://vmpk.sourceforge.net/"
SRC_URI="mirror://sourceforge/vmpk/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="dbus"

BDEPEND="
	app-text/docbook-xsl-stylesheets
	dev-qt/linguist-tools:5
	virtual/pkgconfig
"
RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	>=media-sound/drumstick-1.0.0
	x11-libs/libxcb
	dbus? ( dev-qt/qtdbus:5 )"
DEPEND="${RDEPEND}"

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
	rm -rf "${D}/usr/share/doc/packages" || die
}
