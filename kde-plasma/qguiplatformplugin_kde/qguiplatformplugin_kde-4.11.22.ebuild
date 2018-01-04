# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

KMNAME="kde-workspace"
inherit kde4-base

DESCRIPTION="Helps integration of pure Qt4 applications with KDE Plasma"
KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"
IUSE="debug"

S="${WORKDIR}/${KMNAME}-${PV}/qguiplatformplugin_kde"

PATCHES=( "${FILESDIR}/${P}-cmake.patch" )
