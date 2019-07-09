# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

FRAMEWORKS_MINIMAL="5.53.0"
inherit kde5

DESCRIPTION="Wrapper around exiv2 library"
LICENSE="GPL-2+"
KEYWORDS="amd64 ~arm64 x86"
IUSE="+xmp"

DEPEND="
	$(add_qt_dep qtgui)
	>=media-gfx/exiv2-0.25:=[xmp=]
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-18.12.0-exiv2-0.27.patch" )
