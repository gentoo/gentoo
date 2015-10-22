# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="KDE: Amusing Misuse Of Resources - desktop-dwelling creature"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="x11-libs/libX11
	x11-libs/libXext"
RDEPEND="${DEPEND}"
