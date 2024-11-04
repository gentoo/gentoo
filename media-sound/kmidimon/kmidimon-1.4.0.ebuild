# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="MIDI monitor for ALSA sequencer"
HOMEPAGE="https://kmidimon.sourceforge.io/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="debug"

RDEPEND="
	dev-qt/qt5compat:6
	dev-qt/qtbase:6[gui,widgets]
	media-libs/alsa-lib
	>=media-sound/drumstick-2.9.1[alsa]
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/unzip
	dev-qt/qttools:6[linguist]
"

PATCHES=( "${FILESDIR}/${PN}-1.2.0-fix-cmake-pathvar.patch" )

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOCS=OFF
		-DCMAKE_INSTALL_DOCDIR="${EPREFIX}"/usr/share/doc/${PF}/html
	)
	cmake_src_configure
}
