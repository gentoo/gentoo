# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit gnustep-2

MY_P=Silver.theme-${PV}
DESCRIPTION="a GNUstep silver theme"
HOMEPAGE="http://wiki.gnustep.org/index.php/Silver.theme"
SRC_URI="https://dev.gentoo.org/~voyageur/distfiles/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

pkg_postinst() {
	elog "Use gnustep-apps/systempreferences to switch theme"
}
