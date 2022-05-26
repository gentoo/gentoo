# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg cmake git-r3

DESCRIPTION="Qt GUI to control the JACK Audio Connection Kit and ALSA sequencer connections"
HOMEPAGE="https://qjackctl.sourceforge.io/"
EGIT_REPO_URI="https://git.code.sf.net/p/qjackctl/code"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
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

src_configure() {
	local mycmakeargs=(
		-DCONFIG_ALSA_SEQ=$(usex alsa 1 0)
		-DCONFIG_DBUS=$(usex dbus 1 0)
		-DCONFIG_DEBUG=$(usex debug 1 0)
		-DCONFIG_PORTAUDIO=$(usex portaudio 1 0)
	)
	cmake_src_configure
}
