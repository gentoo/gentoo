# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Half-Life Software Development Kit for mod authors"
HOMEPAGE="http://www.valvesoftware.com/hlsdk.htm"
SRC_URI="http://www.metamod.org/files/sdk/${P}.tgz"

LICENSE="ValveSDK"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

src_prepare() {
	default
	find -iname '*.orig' -exec rm -f '{}' + || die
}

src_install() {
	insinto "$(get_libdir)"/${PN}
	doins -r multiplayer singleplayer
	dodoc metamod.hlsdk-2.3.txt metamod.hlsdk-2.3.patch
}
