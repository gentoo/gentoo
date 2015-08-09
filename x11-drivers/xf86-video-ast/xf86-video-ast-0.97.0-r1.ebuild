# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit xorg-2

DESCRIPTION="X.Org driver for ASpeedTech cards"
KEYWORDS="amd64 x86 ~amd64-fbsd ~x86-fbsd"
LICENSE="MIT"
IUSE=""

PATCHES=(
	"${FILESDIR}"/${P}-remove-mibstore_h.patch
)
