# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

KDE_LINGUAS="br de el es fr hu it nb nl pl ro ru sr sr@Latn tr zh_CN"
inherit kde4-base

MY_P="cwp-${PV}"

DESCRIPTION="KDE Plasma 4 weather plasmoid. It aims to be highly customizable."
HOMEPAGE="http://www.kde-look.org/content/show.php/Customizable+Weather+Plasmoid?content=98925"
SRC_URI="http://www.kde-look.org/CONTENT/content-files/98925-${MY_P}.tar.bz2"

LICENSE="GPL-3"
SLOT="4"
KEYWORDS="amd64 ~x86"
IUSE="debug"

RDEPEND="
	$(add_kdebase_dep plasma-workspace)
"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}
