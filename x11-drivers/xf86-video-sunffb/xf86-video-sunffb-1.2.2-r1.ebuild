# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
