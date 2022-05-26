# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

VDPAUINFO_COMMIT="da66af25aa327d21179d478f3a6d8c03b6c7f574"

DESCRIPTION="Displays info about your card's VDPAU support"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/VDPAU"
SRC_URI="https://gitlab.freedesktop.org/vdpau/vdpauinfo/-/archive/${VDPAUINFO_COMMIT}/${P}.tar.gz"
S="${WORKDIR}/${PN}-${VDPAUINFO_COMMIT}"

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
}
