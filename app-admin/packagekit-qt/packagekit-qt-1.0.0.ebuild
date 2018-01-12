# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="PackageKit-Qt"
MY_P=${MY_PN}-${PV}
inherit cmake-utils

DESCRIPTION="Qt PackageKit backend library"
HOMEPAGE="http://www.packagekit.org/"
SRC_URI="https://github.com/hughsie/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/1"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND="
	>=app-admin/packagekit-base-0.9
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
"
DEPEND="${RDEPEND}
	dev-libs/libxslt
	virtual/pkgconfig
"

S="${WORKDIR}/${MY_P}"
