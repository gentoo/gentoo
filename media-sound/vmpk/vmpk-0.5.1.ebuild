# Copyright 1999-2013 Gentoo Foundation
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
IUSE="alsa dbus jack"

RDEPEND=">=dev-qt/qtcore-4.8:4
	>=dev-qt/qtgui-4.8:4
	>=dev-qt/qtsvg-4.8:4
	alsa? ( media-libs/alsa-lib )
	dbus? ( >=dev-qt/qtdbus-4.8:4 )
	jack? ( media-sound/jack-audio-connection-kit )"
DEPEND="${RDEPEND}
	app-text/docbook-xsl-stylesheets
	virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog NEWS README TODO )

src_configure() {
	local mycmakeargs=(
		"$(cmake-utils_use_enable alsa ALSA)"
		"$(cmake-utils_use_enable dbus DBUS)"
		"$(cmake-utils_use_enable jack JACK)"
		)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	rm -rf "${D}/usr/share/doc/packages"
}
