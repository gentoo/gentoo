# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit kde4-base

DESCRIPTION="KDE4 plasmoid. Reminds us to take our eyes off the screen"
HOMEPAGE="http://www.kde-look.org/content/show.php/Eyesaver?content=89989"
SRC_URI="http://www.kde-look.org/CONTENT/content-files/89989-${P}.tar.gz"

LICENSE="GPL-1"
# License unclear, HOMEPAGE and .desktop file have "GPL", assuming GPL-1.
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="debug"

DEPEND="media-libs/phonon[qt4]"
RDEPEND="
	${DEPEND}
	$(add_kdebase_dep plasma-workspace)
"

PATCHES=( "${FILESDIR}/eyesaver-0.2a-fix.patch" )
