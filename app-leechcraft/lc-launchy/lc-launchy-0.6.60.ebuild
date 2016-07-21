# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit leechcraft toolchain-funcs

DESCRIPTION="Allows one to launch third-party applications (as well as LeechCraft plugins) from LeechCraft"

SLOT="0"
KEYWORDS=" amd64 x86"
IUSE=""

DEPEND="~app-leechcraft/lc-core-${PV}
	dev-qt/qtdeclarative:4"
RDEPEND="${DEPEND}
	~virtual/leechcraft-trayarea-${PV}"
