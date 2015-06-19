# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gnustep-silver-theme/gnustep-silver-theme-3.1.ebuild,v 1.1 2014/02/12 09:11:43 voyageur Exp $

EAPI=5
inherit gnustep-2

MY_P=Silver.theme-${PV}
DESCRIPTION="a GNUstep silver theme"
HOMEPAGE="http://wiki.gnustep.org/index.php/Silver.theme"
SRC_URI="http://download.gna.org/gnustep-nonfsf/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

pkg_postinst() {
	elog "Use gnustep-apps/systempreferences to switch theme"
}
