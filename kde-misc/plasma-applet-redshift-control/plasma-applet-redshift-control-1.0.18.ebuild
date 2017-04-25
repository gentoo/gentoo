# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit kde5

DESCRIPTION="Plasma 5 applet for controlling redshift"
HOMEPAGE="http://kde-apps.org/content/show.php/Redshift+Control?content=170746 https://github.com/kotelnik/plasma-applet-redshift-control/"
SRC_URI="https://github.com/kotelnik/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64"
IUSE=""

DEPEND="$(add_frameworks_dep plasma)"
RDEPEND="${DEPEND}
	x11-misc/redshift
"
