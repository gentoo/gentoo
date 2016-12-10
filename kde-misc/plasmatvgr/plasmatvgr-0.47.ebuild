# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde4-base versionator

MY_PV=$(replace_version_separator . '')
MY_P=${PN}${MY_PV}

DESCRIPTION="Plasmoid which shows greek TV program"
HOMEPAGE="http://www.kde-look.org/content/show.php/plasmatvgr?content=75728"
SRC_URI="http://www.kde-look.org/CONTENT/content-files/75728-${MY_P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="debug"

RDEPEND="
	kde-plasma/plasma-workspace:4
"
S="${WORKDIR}/${PN}"
