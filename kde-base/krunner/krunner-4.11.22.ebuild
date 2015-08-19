# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KMNAME="kde-workspace"
OPENGL_REQUIRED="optional"
inherit kde4-meta

DESCRIPTION="KDE Command Runner"
HOMEPAGE+=" http://userbase.kde.org/Plasma/Krunner"
IUSE="debug"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"

DEPEND="
	$(add_kdebase_dep kcheckpass)
	$(add_kdebase_dep kephal)
	$(add_kdebase_dep ksmserver)
	$(add_kdebase_dep ksysguard)
	$(add_kdebase_dep libkworkspace)
	$(add_kdebase_dep libplasmagenericshell)
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
