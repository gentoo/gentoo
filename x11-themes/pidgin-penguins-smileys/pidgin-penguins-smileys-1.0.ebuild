# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Penguins pidgin smiley theme"
HOMEPAGE="https://gnome-look.org/content/show.php?content=62566"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
S="${WORKDIR}/penguins"

LICENSE="GPL-1+"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="net-im/pidgin"
DEPEND="app-arch/unzip
	!x11-themes/pidgin-smileys"

src_install() {
	dodoc readme.txt
	rm {readme,emots}.txt || die
	insinto /usr/share/pixmaps/pidgin/emotes/penguins
	doins -r .
}
