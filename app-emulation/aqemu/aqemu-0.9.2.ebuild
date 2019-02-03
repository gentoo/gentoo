# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="Graphical interface for QEMU and KVM emulators, using Qt5"
HOMEPAGE="https://sourceforge.net/projects/aqemu"
SRC_URI="https://github.com/tobimensch/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="vnc"

RDEPEND="app-emulation/qemu
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5
	dev-qt/qtprintsupport:5
	dev-qt/qttest:5
	dev-qt/qtwidgets:5
	vnc? ( net-libs/libvncserver )"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS CHANGELOG README TODO )
PATCHES=( "${FILESDIR}/${PN}-0.9.2-qtbindir.patch" )

src_configure() {
	local mycmakeargs=(
		"-DMAN_PAGE_COMPRESSOR="
		"-DWITHOUT_EMBEDDED_DISPLAY=$(usex vnc "OFF" "ON")"
	)

	cmake-utils_src_configure
}
