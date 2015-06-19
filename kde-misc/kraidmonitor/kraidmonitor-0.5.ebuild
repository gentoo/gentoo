# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/kraidmonitor/kraidmonitor-0.5.ebuild,v 1.2 2014/08/05 16:31:46 mrueg Exp $

EAPI=5

inherit kde4-base

DESCRIPTION="Indicator widget for raid arrays"
HOMEPAGE="http://kde-apps.org/content/show.php/K+Raid+Monitor?content=68553"
SRC_URI="http://kde-look.org/CONTENT/content-files/68553-${PN}_${PV}.tar.gz"

LICENSE="GPL-3+"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="
	    $(add_kdebase_dep plasma-workspace)
"

S=${WORKDIR}/${PN}
