# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

VIRTUALX_REQUIRED="test"
inherit kde4-base

DESCRIPTION="Todo management application for KDE"
HOMEPAGE="https://zanshin.kde.org/"
SRC_URI="https://files.kde.org/${PN}/${P}.tar.bz2"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="debug"

RDEPEND="
	$(add_kdebase_dep kdepim-runtime '' 4.6.0)
	dev-libs/boost
"
DEPEND=${RDEPEND}

RESTRICT="test"
