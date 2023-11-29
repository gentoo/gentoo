# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.0-gtk3"
inherit cmake wxwidgets

DESCRIPTION="Driver and GUI for LMS7002M-based SDR platforms"
HOMEPAGE="https://myriadrf.org/projects/component/limesdr/"
SRC_URI="https://github.com/myriadrf/LimeSuite/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/LimeSuite-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	x11-libs/fltk:1
	x11-libs/wxGTK:${WX_GTK_VER}
	net-wireless/soapysdr:=
	virtual/opengl
	virtual/libusb:1"
RDEPEND="${DEPEND}"

src_configure() {
	setup-wxwidgets

	local mycmakeargs=(
		-DENABLE_OCTAVE=OFF
		-DENABLE_EXAMPLES=OFF
	)
	cmake_src_configure
}
