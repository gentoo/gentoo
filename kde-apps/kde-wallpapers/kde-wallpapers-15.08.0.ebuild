# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KMNAME="kde-wallpapers"
KDE_AUTODEPS="false"
KDE_SCM="svn"
inherit kde5

DESCRIPTION="KDE wallpapers"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="!kde-apps/kde-wallpapers:4"

src_configure() {
	local mycmakeargs=( -DWALLPAPER_INSTALL_DIR="${EPREFIX}/usr/share/wallpapers" )

	kde5_src_configure
}
