# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Qt GUI ALSA tools: mixer, configuration browser"
HOMEPAGE="https://gitlab.com/sebholt/qastools"
SRC_URI="https://gitlab.com/sebholt/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.gz"
S="${WORKDIR}"/${PN}-v${PV}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-qt/qtbase:6[dbus,gui,network,widgets]
	dev-qt/qtsvg:6
	media-libs/alsa-lib
	virtual/libudev:=
"
DEPEND="${RDEPEND}"
BDEPEND="dev-qt/qttools:6[linguist]"

PATCHES=( "${FILESDIR}/${PN}-0.23.0-nomancompress.patch" )

src_configure() {
	local mycmakeargs=(
		-DSKIP_LICENSE_INSTALL=ON
		-DCMAKE_DISABLE_FIND_PACKAGE_UnixCommands=ON
	)
	cmake_src_configure
}
