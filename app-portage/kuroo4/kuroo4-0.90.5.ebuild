# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde4-base

DESCRIPTION="Graphical Portage frontend based on KDELibs4/Qt4"
HOMEPAGE="http://kuroo.sourceforge.net/"
SRC_URI="mirror://sourceforge/kuroo/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="debug"

DEPEND="dev-db/sqlite:3"

RDEPEND="${DEPEND}
	app-portage/gentoolkit
	|| ( kde-plasma/kde-cli-tools[kdesu] $(add_kdeapps_dep kdesu) )
	kde-apps/kompare:*
"
