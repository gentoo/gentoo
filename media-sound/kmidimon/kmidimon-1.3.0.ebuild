# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="MIDI monitor for ALSA sequencer"
HOMEPAGE="https://kmidimon.sourceforge.io/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	media-libs/alsa-lib
	>=media-sound/drumstick-2.4.0
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/unzip
	dev-qt/linguist-tools:5
"

PATCHES=( "${FILESDIR}/${PN}-1.2.0-fix-cmake-pathvar.patch" )

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOCS=OFF
		-DCMAKE_INSTALL_DOCDIR="${EPREFIX}"/usr/share/doc/${PF}/html
		-DUSE_QT=5
	)
	cmake_src_configure
}
