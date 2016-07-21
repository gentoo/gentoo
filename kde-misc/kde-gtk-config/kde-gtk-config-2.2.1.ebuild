# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_LINGUAS="bs ca ca@valencia cs da de el es et eu fi fr ga gl hu id it ja kk
km lt mr nb nds nl pl pt pt_BR ro ru sk sl sv uk zh_CN zh_TW"
inherit kde4-base

DESCRIPTION="KDE systemsettings kcm to set GTK application look&feel"
HOMEPAGE="https://projects.kde.org/kde-gtk-config"
SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz"

LICENSE="GPL-3"
KEYWORDS="amd64 ~arm x86 ~x86-fbsd"
SLOT="4"
IUSE="debug"

CDEPEND="
	dev-libs/glib:2
	x11-libs/gtk+:2
	x11-libs/gtk+:3
"
DEPEND="
	${CDEPEND}
	dev-util/automoc
"
RDEPEND="
	${CDEPEND}
	!kde-misc/kcm_gtk
	$(add_kdeapps_dep kcmshell)
"

PATCHES=( "${FILESDIR}/${P}-kdelibs-4.14.11.patch" )

pkg_postinst() {
	kde4-base_pkg_postinst
	einfo
	elog "If you notice missing icons in your GTK applications, you may have to install"
	elog "the corresponding themes for GTK. A good guess would be x11-themes/oxygen-gtk"
	elog "for example."
	einfo
}
