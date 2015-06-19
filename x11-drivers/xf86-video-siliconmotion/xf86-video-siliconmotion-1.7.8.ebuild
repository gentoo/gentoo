# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-siliconmotion/xf86-video-siliconmotion-1.7.8.ebuild,v 1.1 2015/05/09 17:14:10 mattst88 Exp $

EAPI=5
inherit xorg-2

DESCRIPTION="Silicon Motion video driver"

KEYWORDS="amd64 ~mips x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND=">=x11-base/xorg-server-1.0.99"
DEPEND="${RDEPEND}"
