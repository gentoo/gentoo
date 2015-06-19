# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-glint/xf86-video-glint-1.2.7.ebuild,v 1.6 2012/08/26 19:43:15 armin76 Exp $

EAPI=4

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
