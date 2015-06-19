# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libcec/libcec-2.1.4.ebuild,v 1.2 2014/05/16 03:30:48 mrueg Exp $

EAPI=5

inherit autotools eutils linux-info

DESCRIPTION="Library for communicating with the Pulse-Eight USB HDMI-CEC Adaptor"
HOMEPAGE="http://libcec.pulse-eight.com"
SRC_URI="http://github.com/Pulse-Eight/${PN}/archive/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm ~amd64 ~x86"
IUSE="debug static-libs"

RDEPEND="virtual/udev
	dev-libs/lockdev"
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
	econf $(use_enable static-libs static) \
	$(use_enable debug) \
	--enable-optimisation \
	--disable-rpi \
	--disable-cubox
}

src_install() {
	default
	use static-libs || find "${ED}" -name '*.la' -delete
}
