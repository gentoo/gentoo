# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Load monitoring dockapp displaying dancing flame"
HOMEPAGE="https://github.com/kennbr34/wmfire"
SRC_URI="https://github.com/kennbr34/wmfire/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="x11-libs/gtk+:3
	gnome-base/libgtop:2
	x11-libs/libX11
	x11-libs/libXext"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( AUTHORS ChangeLog NEWS README )

src_prepare() {
	default
	eautoreconf
}
