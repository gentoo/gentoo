# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde5

DESCRIPTION="Official GTK+ port of KDE's Breeze widget style"
HOMEPAGE="https://projects.kde.org/projects/kde/workspace/breeze-gtk"
LICENSE="LGPL-2.1+"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND="!<x11-libs/gtk+-3.20:3"

src_configure() {
	local mycmakeargs=(
		-DWITH_GTK3_VERSION=3.20
	)
	kde5_src_configure
}
