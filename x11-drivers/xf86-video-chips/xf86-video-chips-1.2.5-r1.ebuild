# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit xorg-2

DESCRIPTION="Chips and Technologies video driver"

KEYWORDS="amd64 ia64 ppc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

PATCHES=(
	"${FILESDIR}"/${P}-remove-mibstore_h.patch
)
