# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="PipeWire Graph Qt GUI Interface"
HOMEPAGE="https://gitlab.freedesktop.org/rncbc/qpwgraph"
SRC_URI="https://gitlab.freedesktop.org/rncbc/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

IUSE="alsa trayicon wayland"

BDEPEND="dev-qt/linguist-tools:5"
DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	media-video/pipewire
	trayicon? ( dev-qt/qtnetwork:5 )
"
RDEPEND="${DEPEND}
	dev-qt/qtsvg:5
"

S=${WORKDIR}/${PN}-v${PV}

PATCHES=( "${FILESDIR}/${PV}-multiple_user.patch" )

src_configure() {
	local mycmakeargs=(
		-DCONFIG_ALSA_MIDI=$(usex alsa)
		-DCONFIG_SYSTEM_TRAY=$(usex trayicon)
		-DCONFIG_WAYLAND=$(usex wayland)
		-DCONFIG_QT6=0
	)
	cmake_src_configure
}
