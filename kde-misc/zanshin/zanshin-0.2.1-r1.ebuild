# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/zanshin/zanshin-0.2.1-r1.ebuild,v 1.2 2014/05/05 22:51:52 johu Exp $

EAPI=5

VIRTUALX_REQUIRED="test"
inherit kde4-base

DESCRIPTION="Todo management application for KDE"
HOMEPAGE="http://zanshin.kde.org/"
SRC_URI="http://files.kde.org/${PN}/${P}.tar.bz2"

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
