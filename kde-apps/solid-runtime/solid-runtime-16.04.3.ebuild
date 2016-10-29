# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KMNAME="kde-runtime"
KMNOMODULE=true
inherit kde4-meta

DESCRIPTION="KDE SC solid runtime modules (autoeject, automounter and others)"
HOMEPAGE="https://solid.kde.org"
KEYWORDS="amd64 ~arm x86"
IUSE="debug bluetooth networkmanager"

KMEXTRA="
	solid-device-automounter/
	solid-hardware/
	solid-networkstatus/
	solidautoeject/
	soliduiserver/
"

DEPEND=""
RDEPEND="${DEPEND}
	bluetooth? ( || ( net-wireless/bluedevil kde-plasma/bluedevil ) )
	networkmanager? ( || ( kde-plasma/plasma-nm:* kde-misc/networkmanagement ) )
"

PATCHES=( "${FILESDIR}/${PN}-4.14.3-networkmanager-1.0.6.patch" )
