# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://git.code.sf.net/p/qjackctl/code"
	inherit git-r3
else
	SRC_URI="https://downloads.sourceforge.net/qjackctl/${P}.tar.gz"
	KEYWORDS="amd64 x86"
fi

DESCRIPTION="Qt GUI to control the JACK Audio Connection Kit and ALSA sequencer connections"
HOMEPAGE="https://qjackctl.sourceforge.io/"

LICENSE="GPL-2"
SLOT="0"
IUSE="alsa dbus debug portaudio"

DEPEND="
	dev-qt/qtbase:6[dbus?,gui,network,widgets,xml]
	virtual/jack
	alsa? ( media-libs/alsa-lib )
	portaudio? ( media-libs/portaudio )
"
RDEPEND="${DEPEND}
	dev-qt/qtsvg:6
"
BDEPEND="dev-qt/qttools:6[linguist]"

src_configure() {
	local mycmakeargs=(
		-DCONFIG_ALSA_SEQ=$(usex alsa 1 0)
		-DCONFIG_DBUS=$(usex dbus 1 0)
		-DCONFIG_DEBUG=$(usex debug 1 0)
		-DCONFIG_PORTAUDIO=$(usex portaudio 1 0)
		-DCONFIG_QT6=yes
	)
	cmake_src_configure
}
