# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/plasmatvgr/plasmatvgr-0.47.ebuild,v 1.4 2014/03/21 18:59:02 johu Exp $

EAPI=5

inherit kde4-base versionator

MY_PV=$(replace_version_separator . '')
MY_P=${PN}${MY_PV}

DESCRIPTION="KDE4 plasmoid which shows greek TV program"
HOMEPAGE="http://www.kde-look.org/content/show.php/plasmatvgr?content=75728"
SRC_URI="http://www.kde-look.org/CONTENT/content-files/75728-${MY_P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="debug"

RDEPEND="
	$(add_kdebase_dep plasma-workspace)
"
S="${WORKDIR}/${PN}"
