# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

KDE_QTHELP="false"
VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Framework providing additional format plugins for Qt's image I/O system"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="eps openexr"

DEPEND="
	$(add_frameworks_dep karchive)
	$(add_qt_dep qtgui)
	eps? ( $(add_qt_dep qtprintsupport) )
	openexr? (
		media-libs/ilmbase:=
		media-libs/openexr:=
	)
"
RDEPEND="${DEPEND}"

DOCS=( src/imageformats/AUTHORS )

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package eps Qt5PrintSupport)
		$(cmake-utils_use_find_package openexr OpenEXR)
	)

	kde5_src_configure
}
