# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-sunffb/xf86-video-sunffb-1.2.2-r1.ebuild,v 1.1 2013/07/03 08:13:45 chithanh Exp $

EAPI=5

inherit xorg-2

DESCRIPTION="SUNFFB video driver"

KEYWORDS="-* ~sparc"
IUSE=""

RDEPEND=">=x11-base/xorg-server-1.0.99"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-unbreak-when-xaa-is-not-present.patch
)
