# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="A library and tools for working with ZBC and ZAC disks"
HOMEPAGE="https://github.com/hgst/libzbc"
SRC_URI="https://github.com/hgst/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2 GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk"

DEPEND="virtual/pkgconfig
	>=sys-kernel/linux-headers-4.13
	gtk? ( x11-libs/gtk+:3 )"

PATCHES=(
	"${FILESDIR}/libzbc-no-automagic-gtk-dep.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_with gtk gtk3)
}
