# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Qt5 GUI ALSA tools: mixer, configuration browser"
HOMEPAGE="https://gitlab.com/sebholt/qastools"
SRC_URI="https://gitlab.com/sebholt/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

BDEPEND="
	dev-qt/linguist-tools:5
"
RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	media-libs/alsa-lib
	virtual/libudev:=
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${P}-nomancompress.patch" )

S="${WORKDIR}"/${PN}-v${PV}

src_configure() {
	local mycmakeargs=(
		-DSKIP_LICENSE_INSTALL=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_UnixCommands=ON
	)
	cmake_src_configure
}
