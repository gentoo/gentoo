# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="PipeWire Graph Qt GUI Interface"
HOMEPAGE="https://gitlab.freedesktop.org/rncbc/qpwgraph"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.freedesktop.org/rncbc/qpwgraph"
else
	SRC_URI="https://gitlab.freedesktop.org/rncbc/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.bz2"
	S="${WORKDIR}/${PN}-v${PV}"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-2"
SLOT="0"

IUSE="alsa"

BDEPEND="
	dev-qt/qttools:6[linguist]
"
DEPEND="
	dev-qt/qtbase:6[gui,network,widgets,xml]
	dev-qt/qtsvg:6
	media-video/pipewire:=
	alsa? ( media-libs/alsa-lib )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DCONFIG_ALSA_MIDI=$(usex alsa)
		-DCONFIG_SYSTEM_TRAY=1
		-DCONFIG_WAYLAND=1
		-DCONFIG_QT6=1
	)
	cmake_src_configure
}
