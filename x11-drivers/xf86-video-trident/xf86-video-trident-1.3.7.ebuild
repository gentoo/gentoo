# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-trident/xf86-video-trident-1.3.7.ebuild,v 1.1 2015/03/30 17:19:18 mattst88 Exp $

EAPI=5
inherit xorg-2

DESCRIPTION="Trident video driver"
KEYWORDS="amd64 ia64 ppc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND=">=x11-base/xorg-server-1.0.99"
DEPEND="${RDEPEND}"
