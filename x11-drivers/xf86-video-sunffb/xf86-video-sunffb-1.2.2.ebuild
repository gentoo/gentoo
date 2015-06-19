# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-sunffb/xf86-video-sunffb-1.2.2.ebuild,v 1.1 2013/01/23 06:07:45 mattst88 Exp $

inherit x-modular

DESCRIPTION="SUNFFB video driver"

KEYWORDS="-* ~sparc"
IUSE=""

RDEPEND=">=x11-base/xorg-server-1.0.99"
DEPEND="${RDEPEND}
	x11-proto/fontsproto
	x11-proto/randrproto
	x11-proto/renderproto
	x11-proto/xextproto
	x11-proto/xproto"
