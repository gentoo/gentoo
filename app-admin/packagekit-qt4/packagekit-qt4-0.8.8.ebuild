# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/packagekit-qt4/packagekit-qt4-0.8.8.ebuild,v 1.2 2014/03/10 14:26:35 kensington Exp $

EAPI="5"

inherit eutils cmake-utils

MY_PN="PackageKit-Qt"
MY_P=${MY_PN}-${PV}

DESCRIPTION="Qt4 PackageKit backend library"
HOMEPAGE="http://www.packagekit.org/"
SRC_URI="http://www.packagekit.org/releases/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND=">=dev-qt/qtcore-4.4.0:4
	>=dev-qt/qtdbus-4.4.0:4
	>=dev-qt/qtsql-4.4.0:4
	>=app-admin/packagekit-base-0.8.15-r1"
DEPEND="${RDEPEND}
	dev-libs/libxslt
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"
