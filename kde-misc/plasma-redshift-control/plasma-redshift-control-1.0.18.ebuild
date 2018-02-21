# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="plasma-applet-redshift-control"
inherit kde5

DESCRIPTION="Plasma 5 applet for controlling redshift"
HOMEPAGE="https://store.kde.org/p/998916/"
SRC_URI="https://github.com/kotelnik/${MY_PN}/archive/v${PV}.tar.gz -> ${MY_PN}-${PV}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64"
IUSE=""

DEPEND="$(add_frameworks_dep plasma)"
RDEPEND="${DEPEND}
	x11-misc/redshift
"

S="${WORKDIR}/${MY_PN}-${PV}"
