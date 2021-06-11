# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="a system tray dockapp with the ability to display more than just four tray icons"
HOMEPAGE="https://sourceforge.net/projects/wmsystemtray/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

DEPEND="x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXmu
	x11-libs/libXpm"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-ar.patch )

src_prepare() {
	default
	eautoreconf
}
