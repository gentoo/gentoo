# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils cmake-utils

DESCRIPTION="An open source poker client and server"
HOMEPAGE="http://www.holdingnuts.net/"
SRC_URI="http://downloads.sourceforge.net/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="alsa debug dedicated"

RDEPEND="
	!dedicated? (
		dev-qt/qtcore:4
		dev-qt/qtgui:4
		alsa? ( >=media-libs/libsdl-1.2.10:0[alsa] )
	)"

DEPEND="${RDEPEND}
	>=dev-util/cmake-2.6.3"

PATCHES=(
	"${FILESDIR}"/${P}-wheel.patch # upstream patch (bug #307901)
)

src_prepare() {
	default

	sed -i -e '/^Path/d' holdingnuts.desktop || die
}

src_configure() {
	local mycmakeargs=(-DWITH_AUDIO=$(usex alsa)
		-DENABLE_CLIENT=$(usex !dedicated)
		-DWITH_DEBUG=$(usex debug))
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	if ! use dedicated ; then
		domenu ${PN}.desktop
		doicon ${PN}.png
		doman docs/${PN}.6
	fi

	dodoc ChangeLog docs/protocol_spec.txt
	doman docs/${PN}-server.6
}
