# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

DESCRIPTION="Library with common classes and functionality used by KDE finance applications"
HOMEPAGE="https://community.kde.org/Alkimia/libalkimia"
SRC_URI="mirror://kde/stable/${PN/lib/}/${PV}/src/${P}.tar.xz"

LICENSE="LGPL-2.1+"
KEYWORDS="~amd64 ~x86"
SLOT="0/5"
IUSE=""

RDEPEND="
	dev-libs/gmp:0=[cxx]
	dev-qt/qtcore:4
	dev-qt/qtdbus:4
	kde-base/kdelibs:4
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"
