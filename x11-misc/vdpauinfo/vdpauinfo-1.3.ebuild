# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="Displays info about your card's VDPAU support"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/VDPAU"
SRC_URI="https://gitlab.freedesktop.org/vdpau/${PN}/-/archive/${P}/${PN}-${P}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	x11-libs/libX11
	>=x11-libs/libvdpau-1.3
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	x11-base/xorg-proto
"
S=${WORKDIR}/${PN}-${P}

src_prepare() {
	default
	eautoreconf
}
