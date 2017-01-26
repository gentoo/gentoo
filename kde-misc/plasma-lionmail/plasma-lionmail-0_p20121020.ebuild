# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde4-base

DESCRIPTION="Plasma widget displaying new and important email"
HOMEPAGE="https://www.kde.org http://www.vizzzion.org"
SRC_URI="https://dev.gentoo.org/~creffett/distfiles/${P}.tar.xz"

LICENSE="GPL-2 LGPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="
	$(add_kdeapps_dep kdepimlibs)
	kde-apps/akonadi:4
	kde-frameworks/kdelibs:4
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtwebkit:4
"
RDEPEND="${DEPEND}
	$(add_kdeapps_dep kdepim-runtime)
"
