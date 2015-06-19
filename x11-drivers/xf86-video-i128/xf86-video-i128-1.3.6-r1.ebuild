# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-i128/xf86-video-i128-1.3.6-r1.ebuild,v 1.4 2013/10/08 05:06:05 ago Exp $

EAPI=5

inherit xorg-2

DESCRIPTION="Number 9 I128 video driver"

KEYWORDS="amd64 ia64 x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND=">=x11-base/xorg-server-1.0.99"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-remove-mibstore_h.patch
)
