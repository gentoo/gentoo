# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit cmake-utils eutils

DESCRIPTION="Virtual MIDI Piano Keyboard"
HOMEPAGE="http://vmpk.sourceforge.net/"
SRC_URI="mirror://sourceforge/vmpk/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="dbus"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/linguist-tools:5
	dev-qt/qtx11extras:5
	x11-libs/libxcb
	>=media-sound/drumstick-1.0.0
	dbus? ( dev-qt/qtdbus:5 )"
DEPEND="${RDEPEND}
	app-text/docbook-xsl-stylesheets
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog NEWS README TODO )

src_configure() {
	local mycmakeargs=(
		"$(cmake-utils_use_enable dbus DBUS)"
		)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	rm -rf "${D}/usr/share/doc/packages"
}
