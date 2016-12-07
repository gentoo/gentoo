# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KMNAME="kde-workspace"
OPENGL_REQUIRED="optional"
inherit kde4-meta

DESCRIPTION="KDE Plasma Command Runner"
HOMEPAGE+=" https://userbase.kde.org/Plasma/Krunner"
IUSE="debug"
KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"

DEPEND="
	kde-plasma/kcheckpass:4
	kde-plasma/kephal:4
	kde-plasma/ksmserver:4
	kde-plasma/ksysguard:4
	kde-plasma/libkworkspace:4
	kde-plasma/libplasmagenericshell:4
	!aqua? (
		x11-libs/libX11
		x11-libs/libXcursor
		x11-libs/libXext
	)
"
RDEPEND="${DEPEND}"

KMEXTRACTONLY="
	libs/kdm/
	libs/kephal/
	libs/ksysguard/
	libs/kworkspace/
	libs/plasmagenericshell/
	kcheckpass/
	ksmserver/org.kde.KSMServerInterface.xml
	ksysguard/
	plasma/screensaver/shell/org.kde.plasma-overlay.App.xml
"

KMLOADLIBS="libkworkspace"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with opengl OpenGL)
	)

	kde4-meta_src_configure
}
