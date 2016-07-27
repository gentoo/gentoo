# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

WEBKIT_REQUIRED="always"
inherit kde4-base

DESCRIPTION="Library for accessing Google calendar and contact resources"
HOMEPAGE="https://projects.kde.org/projects/extragear/libs/libkgapi"
SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 ~arm x86"
IUSE="debug"

DEPEND="
	$(add_kdeapps_dep kdepimlibs '' 4.14)
	dev-libs/qjson
"
RDEPEND="${DEPEND}"
