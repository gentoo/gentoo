# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-voodoo/xf86-video-voodoo-1.2.5.ebuild,v 1.7 2012/12/30 14:52:04 ago Exp $

EAPI=4
inherit xorg-2

DESCRIPTION="Voodoo video driver"
KEYWORDS="alpha amd64 ia64 ppc sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=x11-base/xorg-server-1.0.99"
DEPEND="${RDEPEND}
	x11-proto/xf86dgaproto"
