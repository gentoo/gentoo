# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-video-ast/xf86-video-ast-0.97.0-r1.ebuild,v 1.3 2013/10/08 05:05:42 ago Exp $

EAPI=5

inherit xorg-2

DESCRIPTION="X.Org driver for ASpeedTech cards"
KEYWORDS="amd64 x86 ~amd64-fbsd ~x86-fbsd"
LICENSE="MIT"
IUSE=""

PATCHES=(
	"${FILESDIR}"/${P}-remove-mibstore_h.patch
)
