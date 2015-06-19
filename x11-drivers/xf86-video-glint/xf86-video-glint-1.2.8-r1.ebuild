# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-glint/xf86-video-glint-1.2.8-r1.ebuild,v 1.7 2013/10/08 05:06:02 ago Exp $

EAPI=5

inherit xorg-2

DESCRIPTION="GLINT/Permedia video driver"

KEYWORDS="alpha amd64 ia64 ppc sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND=">=x11-base/xorg-server-1.0.99"
DEPEND="${RDEPEND}
	x11-proto/videoproto
	x11-proto/xextproto
	x11-proto/xf86dgaproto
	x11-proto/xproto"

PATCHES=(
	"${FILESDIR}"/${P}-remove-mibstore_h.patch
)
