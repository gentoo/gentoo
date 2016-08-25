# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="Graphical interface for QEMU and KVM emulators, using Qt5"
HOMEPAGE="https://sourceforge.net/projects/aqemu"
SRC_URI="https://github.com/tobimensch/${PN}/archive/v${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="vnc"

DEPEND="${RDEPEND}"
RDEPEND="app-emulation/qemu
	vnc? ( net-libs/libvncserver )
	dev-qt/qtcore:5
	dev-qt/qtwidgets:5
	dev-qt/qtnetwork:5
	dev-qt/qttest:5
	dev-qt/qtprintsupport:5"

DOCS="AUTHORS CHANGELOG README TODO"
PATCHES=( "${FILESDIR}/${PN}-0.9.2-qtbindir.patch" )

src_configure() {
	local mycmakeargs=(
		"-DMAN_PAGE_COMPRESSOR="
		"-DWITHOUT_EMBEDDED_DISPLAY=$(usex vnc "OFF" "ON")"
	)

	cmake-utils_src_configure
}
