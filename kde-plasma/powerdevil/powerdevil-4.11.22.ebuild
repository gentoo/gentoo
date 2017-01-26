# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KMNAME="kde-workspace"
inherit kde4-meta

DESCRIPTION="PowerDevil is an utility for KDE4 for Laptop Powermanagement"
HOMEPAGE="https://solid.kde.org"
KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"
IUSE="debug +pm-utils"

DEPEND="
	kde-frameworks/kactivities:4
	kde-plasma/libkworkspace:4
	!aqua? (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXrandr
	)
"
RDEPEND="${DEPEND}
	pm-utils? ( sys-power/pm-utils )
"

KMEXTRACTONLY="
	krunner/
	ksmserver/org.kde.KSMServerInterface.xml
	ksmserver/screenlocker/dbus/org.freedesktop.ScreenSaver.xml
"
