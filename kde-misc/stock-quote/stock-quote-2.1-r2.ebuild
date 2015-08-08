# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde4-base

MY_P=plasma_${PN/-/_}-${PV}

DESCRIPTION="Displays stock quotes pulled from the Yahoo! servers"
HOMEPAGE="http://www.kde-look.org/content/show.php/Stock+Quote?content=90695"
SRC_URI="http://www.kde-look.org/CONTENT/content-files/90695-${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="debug"

RDEPEND="
	$(add_kdebase_dep plasma-workspace)
"
S=${WORKDIR}/${MY_P}

DOCS=( CHANGELOG README )

src_prepare() {
	sed -e 's:^[ \t]*::' \
		-i applet/plasma-applet-stock-quote.desktop || die "fixing .desktop file failed"
	sed -e 's:^[ \t]*::' \
		-i dataengine/plasma-dataengine-stockquote.desktop || die "fixing .desktop file failed"
	kde4-base_src_prepare
}
