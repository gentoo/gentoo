# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PV="4.14.3"
inherit kde4-base

DESCRIPTION="Framework for searching and managing metadata"
SRC_URI="
	mirror://kde/stable/${MY_PV}/src/${PN}-${MY_PV}.tar.xz
	https://dev.gentoo.org/~asturm/${P}.tar.xz
"
KEYWORDS="~amd64 ~arm ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdeapps_dep kdepimlibs)
	dev-libs/qjson
	dev-libs/xapian:=[chert]
"
RDEPEND="${DEPEND}
	!<kde-base/nepomuk-4.12.50
"

RESTRICT="test"

PATCHES=( "${WORKDIR}/${P}" ) # intevation branch + disable non-PIM stuff

S="${WORKDIR}/${PN}-${MY_PV}"
