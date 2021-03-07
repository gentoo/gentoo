# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="OpenOfficeorgThumbnail-${PV}"
KFMIN=5.60.0
QTMIN=5.12.3
inherit ecm

DESCRIPTION="Thumbnail-plugin that generates thumbnails for ODF files"
HOMEPAGE="https://www.kde-apps.org/content/show.php?content=110864"
SRC_URI="http://arielch.fedorapeople.org/devel/src/${MY_P}.tar.gz"

LICENSE="LGPL-3"
SLOT="5"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	>=dev-qt/qtgui-${QTMIN}:5
	>=kde-frameworks/karchive-${KFMIN}:5
	>=kde-frameworks/kio-${KFMIN}:5
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

PATCHES=( "${FILESDIR}"/${P}-kf5-support.patch )
