# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-frameworks/kimageformats/kimageformats-5.10.0.ebuild,v 1.1 2015/05/09 10:36:05 mrueg Exp $

EAPI=5

VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Framework providing additional format plugins for Qt's image I/O system"
LICENSE="LGPL-2+"
KEYWORDS="~amd64 ~x86"
IUSE="eps openexr"

RDEPEND="
	dev-qt/qtgui:5
	eps? ( dev-qt/qtprintsupport:5 )
	openexr? (
		media-libs/ilmbase:=
		media-libs/openexr:=
	)
"
DEPEND="${RDEPEND}"

DOCS=( src/imageformats/AUTHORS )

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_find_package eps Qt5PrintSupport)
		$(cmake-utils_use_find_package openexr OpenEXR)
	)

	kde5_src_configure
}
