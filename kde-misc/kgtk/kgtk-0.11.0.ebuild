# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/kgtk/kgtk-0.11.0.ebuild,v 1.4 2014/03/20 22:12:11 johu Exp $

EAPI=5
KDE_LINGUAS="cs de en_GB es fr it pt_BR ru zh_CN"
KDE_LINGUAS_DIR="kdialogd4/po"
inherit kde4-base

MY_PN=KGtk

DESCRIPTION="Allows *some* Gtk and Qt4 applications to use KDE's file dialogs when run under KDE"
HOMEPAGE="http://www.kde-apps.org/content/show.php?content=36077"
SRC_URI="http://www.kde-apps.org/CONTENT/content-files/36077-${MY_PN}-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug"

DEPEND="
	|| ( x11-libs/gtk+:2 x11-libs/gtk+:3 )
	x11-libs/gdk-pixbuf
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	$(add_kdebase_dep kdebase-startkde)
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_PN}-${PV}

DOCS=( AUTHORS ChangeLog README TODO )
PATCHES=( "${FILESDIR}/${P}-include.patch" )

pkg_postinst() {
	kde4-base_pkg_postinst
	elog "To see the kde-file-selector in a gtk-application, just do:"
	elog "cd /usr/local/bin"
	elog "ln -s /usr/bin/kgtk-wrapper application(eg. firefox)"
	elog "Make sure that /usr/local/bin is before /usr/bin in your \$PATH"
	elog
	elog "You need to restart kde and be sure to change your symlinks to non-.sh"
}
