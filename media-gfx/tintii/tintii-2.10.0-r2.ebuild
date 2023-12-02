# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
WX_GTK_VER="3.2-gtk3"

inherit desktop wxwidgets

DESCRIPTION="Photo editor for selective color, saturation, and hue shift adjustments"
HOMEPAGE="https://www.indii.org/software/tintii/"
SRC_URI="https://www.indii.org/files/tint/releases/${P}.tar.gz
	https://dev.gentoo.org/~pacho/${PN}/${PN}_128.png"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	x11-libs/wxGTK:${WX_GTK_VER}[X]
"
DEPEND="${RDEPEND}
	dev-libs/boost
"
BDEPEND="sys-devel/bc"

src_prepare() {
	default
	setup-wxwidgets
}

src_configure() {
	econf --disable-assert
}

src_install() {
	default
	newicon "${DISTDIR}"/${PN}_128.png ${PN}.png
	make_desktop_entry ${PN} Tintii
}
