# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

QT3SUPPORT_REQUIRED="true"
SQL_REQUIRED="always"
inherit kde4-base

DESCRIPTION="KDE flickr.com image uploading program"
HOMEPAGE="http://kflickr.sourceforge.net/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2 FDL-1.2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DOCS=( AUTHORS README )
