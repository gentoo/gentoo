# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_REQUIRED="never"
inherit kde4-base

DESCRIPTION="Scripting Meta Object Kompiler Engine - generators"
KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"
IUSE="debug"
HOMEPAGE="https://techbase.kde.org/Development/Languages/Smoke"

DEPEND="
	dev-qt/qtcore:4[aqua=]
"
RDEPEND="${DEPEND}"
