# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake

MY_P=${P/_/-}

DESCRIPTION="Weak signal ham radio communication"
HOMEPAGE="https://groups.io/g/js8call"
SRC_URI="https://github.com/${PN}/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-qt/qtbase:6[gui,network,widgets]
	dev-qt/qtmultimedia:6
	dev-qt/qtserialport:6
	dev-libs/boost:=
	virtual/libusb:1
	sci-libs/fftw:3.0=[threads,fortran]
	>=media-libs/hamlib-4:= "
DEPEND="${RDEPEND}"

src_install() {
	cmake_src_install
	rm "${D}"/usr/bin/rigctl{,d}-local || die
}
