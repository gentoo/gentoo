# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-tga/xf86-video-tga-1.2.2-r1.ebuild,v 1.5 2013/10/08 05:06:48 ago Exp $

EAPI=5
inherit xorg-2

DESCRIPTION="X.Org driver for tga cards"
KEYWORDS="alpha amd64 ia64 x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND=">=x11-base/xorg-server-1.0.99"
DEPEND="${RDEPEND}
	x11-proto/xf86dgaproto"

PATCHES=(
	"${FILESDIR}"/${P}-remove-mibstore_h.patch
)
