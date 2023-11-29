# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.2-gtk3"
inherit desktop cmake wxwidgets xdg

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

src_install() {
	cmake_src_install

	# https://github.com/myriadrf/LimeSuite/issues/223
	# Upstream installs icon and desktop files to a central location and has
	# a script to move them to the correct locations at postinst time.
	for size in 16 22 32 48 64 128; do
		newicon -s ${size} Desktop/lime-suite-${size}.png lime-suite.png
	done
	domenu Desktop/lime-suite.desktop
	rm -r "${ED}"/usr/share/Lime/Desktop || die
}
