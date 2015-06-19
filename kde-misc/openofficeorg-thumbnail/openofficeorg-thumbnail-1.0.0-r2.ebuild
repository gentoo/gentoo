# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/openofficeorg-thumbnail/openofficeorg-thumbnail-1.0.0-r2.ebuild,v 1.3 2013/03/31 16:58:04 ago Exp $

EAPI=5
MY_PN="OpenOfficeorgThumbnail"
MY_P="${MY_PN}-${PV}"

inherit kde4-base

DESCRIPTION="KDE thumbnail-plugin that generates thumbnails for ODF files"
HOMEPAGE="http://www.kde-apps.org/content/show.php?content=110864"
SRC_URI="http://arielch.fedorapeople.org/devel/src/${MY_P}.tar.gz"

LICENSE="LGPL-3"
KEYWORDS="amd64 x86"
SLOT="4"
IUSE="debug"

S=${WORKDIR}/${MY_P}
