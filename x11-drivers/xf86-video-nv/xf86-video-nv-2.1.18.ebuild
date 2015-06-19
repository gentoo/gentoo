# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-nv/xf86-video-nv-2.1.18.ebuild,v 1.7 2012/05/16 00:54:03 aballier Exp $

EAPI=3

inherit xorg-2

DESCRIPTION="Nvidia 2D only video driver"

KEYWORDS="alpha amd64 ia64 ppc ppc64 x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND="x11-base/xorg-server"
DEPEND="${RDEPEND}
	x11-proto/fontsproto
	x11-proto/randrproto
	x11-proto/renderproto
	x11-proto/videoproto
	x11-proto/xextproto
	x11-proto/xproto"
