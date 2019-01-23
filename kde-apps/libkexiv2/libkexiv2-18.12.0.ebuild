# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

FRAMEWORKS_MINIMAL="5.53.0"
KDE_BLOCK_SLOT4="false"
inherit kde5

DESCRIPTION="KDE Image Plugin Interface: an exiv2 library wrapper"
LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE="+xmp"

DEPEND="
	$(add_qt_dep qtgui)
	>=media-gfx/exiv2-0.25:=[xmp=]
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-exiv2-0.27.patch" )
