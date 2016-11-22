# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

VIRTUALX_REQUIRED="test"
inherit kde4-base

DESCRIPTION="Todo management application by KDE"
HOMEPAGE="https://zanshin.kde.org/"
SRC_URI="https://files.kde.org/${PN}/${P}.tar.bz2"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="
	$(add_kdeapps_dep kdepim-runtime '' 4.6.0)
	$(add_kdeapps_dep kdepimlibs)
	dev-libs/boost
	kde-frameworks/baloo:4
"
RDEPEND="${DEPEND}"

RESTRICT="test"
