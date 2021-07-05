# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg cmake

DESCRIPTION="Qt GUI to control the JACK Audio Connection Kit and ALSA sequencer connections"
HOMEPAGE="https://qjackctl.sourceforge.io/"
SRC_URI="mirror://sourceforge/qjackctl/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa dbus debug portaudio"

BDEPEND="dev-qt/linguist-tools:5"
DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	dev-qt/qtxml:5
	virtual/jack
	alsa? ( media-libs/alsa-lib )
	dbus? ( dev-qt/qtdbus:5 )
	portaudio? ( media-libs/portaudio )
"
RDEPEND="${DEPEND}
	dev-qt/qtsvg:5
"

PATCHES=(
	"${FILESDIR}/${PN}-0.9.1-disable-git.patch"
)

src_configure() {
	local mycmakeargs=(
		-DCONFIG_ALSA_SEQ=$(usex alsa 1 0)
		-DCONFIG_DBUS=$(usex dbus 1 0)
		-DCONFIG_DEBUG=$(usex debug 1 0)
		-DCONFIG_PORTAUDIO=$(usex portaudio 1 0)
	)
	cmake_src_configure
}
