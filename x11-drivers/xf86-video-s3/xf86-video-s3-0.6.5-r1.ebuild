# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-s3/xf86-video-s3-0.6.5-r1.ebuild,v 1.6 2015/02/24 08:38:02 ago Exp $

EAPI=5
inherit xorg-2

DESCRIPTION="X.Org driver for s3 cards"

KEYWORDS="alpha amd64 ia64 ppc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND=">=x11-base/xorg-server-1.0.99"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-mibstore_h.patch
)
