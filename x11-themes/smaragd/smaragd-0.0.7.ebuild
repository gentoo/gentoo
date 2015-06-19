# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/smaragd/smaragd-0.0.7.ebuild,v 1.3 2014/03/21 21:57:57 johu Exp $

EAPI=5

inherit kde4-base

DESCRIPTION="KWin theme engine that uses Emerald themes"
HOMEPAGE="http://kde-look.org/content/show.php?content=125162"
SRC_URI="http://www.kde-look.org/CONTENT/content-files/125162-${P}.tar.gz"

LICENSE="GPL-2"

KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="debug"

DEPEND="
	$(add_kdebase_dep libkworkspace)
	x11-libs/cairo
"
RDEPEND="
	${DEPEND}
	$(add_kdebase_dep kwin)
"
