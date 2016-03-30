# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

MY_PN="OpenOfficeorgThumbnail"
MY_P="${MY_PN}-${PV}"
inherit kde5

DESCRIPTION="KDE thumbnail-plugin that generates thumbnails for ODF files"
HOMEPAGE="http://www.kde-apps.org/content/show.php?content=110864"
SRC_URI="http://arielch.fedorapeople.org/devel/src/${MY_P}.tar.gz"

LICENSE="LGPL-3"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	$(add_frameworks_dep karchive)
	$(add_frameworks_dep kio)
	$(add_qt_dep qtgui)
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

PATCHES=( "${FILESDIR}"/${P}-kf5-support.patch )
