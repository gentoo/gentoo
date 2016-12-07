# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DECLARATIVE_REQUIRED="always"
KMNAME="kde-workspace"
inherit kde4-meta pax-utils

DESCRIPTION="The reliable Plasma session manager that talks the standard X11R6"
KEYWORDS="amd64 ~arm x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	kde-plasma/kcminit:4
	kde-plasma/libkworkspace:4
	media-libs/qimageblitz
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXrender
"
RDEPEND="${DEPEND}
	kde-plasma/libkgreeter:4
"

KMEXTRACTONLY="
	kcminit/main.h
	libs/kdm/kgreeterplugin.h
	kcheckpass/
	libs/kephal/
	libs/kworkspace/
"

KMLOADLIBS="libkworkspace"

src_install() {
	kde4-meta_src_install

	# bug #483236
	pax-mark m "${ED}/usr/$(get_libdir)/kde4/libexec/kscreenlocker_greet"
}
