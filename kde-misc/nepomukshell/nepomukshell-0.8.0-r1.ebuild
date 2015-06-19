# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/nepomukshell/nepomukshell-0.8.0-r1.ebuild,v 1.1 2014/05/13 23:17:57 johu Exp $

EAPI=5

KDE_MINIMAL="4.13.1"
inherit kde4-base

DESCRIPTION="Browse, query, and edit Nepomuk resources"
HOMEPAGE="https://projects.kde.org/projects/extragear/utils/nepomukshell"
SRC_URI="mirror://kde/unstable/nepomuk/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="
	$(add_kdebase_dep kdelibs 'nepomuk')
"

RDEPEND="${DEPEND}"
