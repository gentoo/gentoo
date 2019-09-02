# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WX_GTK_VER="3.0-gtk3"
inherit cmake-utils wxwidgets

DESCRIPTION="Driver and GUI for LMS7002M-based SDR platforms"
HOMEPAGE="https://myriadrf.org/projects/component/limesdr/"
SRC_URI="https://github.com/myriadrf/LimeSuite/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/LimeSuite-${PV}"

DEPEND="x11-libs/fltk
	x11-libs/wxGTK:${WX_GTK_VER}
	net-wireless/soapysdr:=
	virtual/opengl
	virtual/libusb:1"
RDEPEND="${DEPEND}"
BDEPEND=""

src_configure() {
	setup-wxwidgets
	cmake-utils_src_configure
}
