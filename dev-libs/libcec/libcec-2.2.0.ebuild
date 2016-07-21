# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils linux-info

DESCRIPTION="Library for communicating with the Pulse-Eight USB HDMI-CEC Adaptor"
HOMEPAGE="http://libcec.pulse-eight.com"
SRC_URI="https://github.com/Pulse-Eight/${PN}/archive/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="cubox debug exynos raspberry-pi static-libs xrandr"

RDEPEND="virtual/udev
	dev-libs/lockdev
	xrandr? ( x11-libs/libXrandr )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

CONFIG_CHECK="~USB_ACM"

S="${WORKDIR}/${PN}-${P}"

src_prepare() {
	sed -i '/^CXXFLAGS/s:-fPIC::' configure.ac || die
	sed -i '/^CXXFLAGS/s:-Werror::' configure.ac || die
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable cubox ) \
		$(use_enable debug) \
		$(use_enable exynos) \
		$(use_enable raspberry-pi rpi) \
		$(use_enable static-libs static) \
		--enable-optimisation
}

src_install() {
	default
	use static-libs || find "${ED}" -name '*.la' -delete
}
