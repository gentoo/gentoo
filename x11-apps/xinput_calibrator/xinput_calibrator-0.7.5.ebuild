# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
inherit autotools-utils

DESCRIPTION="A generic touchscreen calibration program for X.Org"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/xinput_calibrator"
SRC_URI="mirror://github/tias/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="gtk"

DEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXrandr
	x11-proto/inputproto
	gtk? ( dev-cpp/gtkmm:2.4 )"
RDEPEND="${DEPEND}"

src_configure() {
	local myeconfargs=(
		--with-gui=$(use gtk && echo "gtkmm" || echo "x11")
	)
	autotools-utils_src_configure
}
