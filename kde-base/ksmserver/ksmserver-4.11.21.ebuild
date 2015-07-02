# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/ksmserver/ksmserver-4.11.21.ebuild,v 1.1 2015/07/02 13:23:00 mrueg Exp $

EAPI=5

DECLARATIVE_REQUIRED="always"
KMNAME="kde-workspace"
inherit kde4-meta pax-utils

DESCRIPTION="The reliable KDE session manager that talks the standard X11R6"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdebase_dep kcminit)
	$(add_kdebase_dep libkworkspace)
	media-libs/qimageblitz
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXrender
"
RDEPEND="${DEPEND}
	$(add_kdebase_dep libkgreeter)
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
