# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde5

DESCRIPTION="Official GTK+ port of KDE's Breeze widget style"
HOMEPAGE="https://projects.kde.org/projects/kde/workspace/breeze-gtk"
LICENSE="LGPL-2.1+"
KEYWORDS="amd64 ~arm x86"
IUSE=""

src_install() {
	kde5_src_install

	insinto /usr/share/themes/Breeze/gtk-3.20
	doins Breeze-gtk/gtk-3.20/gtk.css

	insinto /usr/share/themes/Breeze-Dark/gtk-3.20
	doins Breeze-dark-gtk/gtk-3.20/gtk.css
}
