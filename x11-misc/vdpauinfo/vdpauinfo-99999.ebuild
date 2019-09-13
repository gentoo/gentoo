# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools git-r3

DESCRIPTION="Displays info about your card's VDPAU support"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/VDPAU"
EGIT_REPO_URI="https://gitlab.freedesktop.org/vdpau/vdpauinfo"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""

RDEPEND="
	x11-libs/libX11
	>=x11-libs/libvdpau-1.3
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	x11-base/xorg-proto
"

src_prepare() {
	default
	eautoreconf
}
