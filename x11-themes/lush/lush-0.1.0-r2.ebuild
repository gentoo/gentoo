# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

S="${WORKDIR}"
DESCRIPTION="Lush KDE icon theme"
SRC_URI="mirror://gentoo/${P}dave.tar.gz"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=5483"

KEYWORDS="alpha amd64 ia64 ppc sparc x86 ~x86-fbsd"
LICENSE="GPL-1"

SLOT="0"
IUSE=""

RESTRICT="strip binchecks"

src_install(){
	insinto /usr/share/icons
	doins -r lush
}
