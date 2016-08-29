# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="*nix minimizer for a few games"
HOMEPAGE="http://hem.bredband.net/b400150/"
SRC_URI="http://hem.bredband.net/b400150/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXxf86vm
	x11-libs/libXmu
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-libs/libXt
	x11-proto/recordproto
	x11-proto/xf86vidmodeproto
	x11-proto/xproto"

PATCHES=(
		"${FILESDIR}"/${P}-desktop-entry.patch
		"${FILESDIR}"/${P}-glibc.patch
)

src_configure() {
	econf --datadir=/usr/share
}
