# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde4-base

DESCRIPTION="Plasma 4 plasmoid that shows CPU load on the screen"
HOMEPAGE="http://www.kde-look.org/content/show.php/cpuload?content=86628"
SRC_URI="http://kde-look.org/CONTENT/content-files/86628-${P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="debug"

DEPEND="
	kde-plasma/plasma-workspace:4
"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/"${PN}"
