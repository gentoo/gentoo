# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-visualization/labplot/labplot-9999.ebuild,v 1.1 2015/04/15 15:10:28 dilfridge Exp $

EAPI=5

if [[ "${PV}" != "9999" ]]; then
	KEYWORDS="~amd64 ~x86"
	SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.xz"
	inherit kde4-base
else
	EGIT_REPO_URI="git://anongit.kde.org/labplot"
	inherit kde4-base git-r3
fi

MY_PN=LabPlot
MY_P=${MY_PN}-${PV}

DESCRIPTION="KDE data analysis and visualisation program"
HOMEPAGE="https://edu.kde.org/applications/science/labplot/"

LICENSE="GPL-2"
SLOT="4"
IUSE=""

DEPEND="
	sci-libs/gsl
"
RDEPEND="$DEPEND"
