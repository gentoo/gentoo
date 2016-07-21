# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Penguins pidgin smiley theme"
HOMEPAGE="http://gnome-look.org/content/show.php?content=62566"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-1+"
SLOT="0"
IUSE=""
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="net-im/pidgin"
DEPEND="app-arch/unzip
	!x11-themes/pidgin-smileys"

S=${WORKDIR}/penguins

src_install() {
	dodoc readme.txt
	rm {readme,emots}.txt || die
	insinto /usr/share/pixmaps/pidgin/emotes/penguins
	doins *
}
