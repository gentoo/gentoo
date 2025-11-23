# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="Displays info about your card's VDPAU support"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/VDPAU/"
SRC_URI="https://gitlab.freedesktop.org/vdpau/vdpauinfo/-/archive/${PV}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	>=x11-libs/libvdpau-1.5
	x11-libs/libX11"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	eautoreconf

	append-flags -fno-strict-aliasing #864755
}
