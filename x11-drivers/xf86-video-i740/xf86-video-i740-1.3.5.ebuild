# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-i740/xf86-video-i740-1.3.5.ebuild,v 1.1 2015/02/21 20:46:09 mattst88 Exp $

EAPI=5
inherit xorg-2

DESCRIPTION="Intel i740 video driver"

KEYWORDS="amd64 ia64 x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND=">=x11-base/xorg-server-1.0.99"
DEPEND="${RDEPEND}"
