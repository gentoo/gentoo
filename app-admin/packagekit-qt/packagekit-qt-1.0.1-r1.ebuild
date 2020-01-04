# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="PackageKit-Qt"
MY_P=${MY_PN}-${PV}
inherit cmake

DESCRIPTION="Qt PackageKit backend library"
HOMEPAGE="https://www.freedesktop.org/software/PackageKit/"
SRC_URI="https://github.com/hughsie/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/1"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

BDEPEND="
	dev-libs/libxslt
	virtual/pkgconfig
"
DEPEND="
	>=app-admin/packagekit-base-0.9
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"
