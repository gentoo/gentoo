# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit autotools-utils flag-o-matic

DESCRIPTION="A generic touchscreen calibration program for X.Org"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/xinput_calibrator"
SRC_URI="mirror://github/tias/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="gtk"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXrandr
	gtk? ( dev-cpp/gtkmm:2.4 )"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

src_configure() {
	append-cxxflags -std=c++11 #566594

	local myeconfargs=(
		--with-gui=$(use gtk && echo "gtkmm" || echo "x11")
	)
	autotools-utils_src_configure
}
