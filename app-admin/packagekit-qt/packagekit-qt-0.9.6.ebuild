# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

MY_PN="PackageKit-Qt"
MY_P=${MY_PN}-${PV}

DESCRIPTION="Qt PackageKit backend library"
HOMEPAGE="http://www.packagekit.org/"
SRC_URI="https://www.freedesktop.org/software/PackageKit/releases/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND="
	>=app-admin/packagekit-base-0.9
	>=dev-qt/qtcore-5.6:5
	>=dev-qt/qtdbus-5.6:5
	>=dev-qt/qtsql-5.6:5
"
DEPEND="${RDEPEND}
	dev-libs/libxslt
	virtual/pkgconfig
"

S="${WORKDIR}/${MY_P}"
