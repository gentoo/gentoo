# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gnustep-silver-theme/gnustep-silver-theme-2.5.ebuild,v 1.1 2012/02/22 10:12:01 voyageur Exp $

EAPI=4
inherit gnustep-2

DESCRIPTION="a GNUstep silver theme"
HOMEPAGE="http://wiki.gnustep.org/index.php/Themes"
SRC_URI="http://download.gna.org/gnustep-nonfsf/silver.theme-${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S=${WORKDIR}/Silver.theme

src_install() {
	egnustep_env

	#install themes
	insinto ${GNUSTEP_SYSTEM_LIBRARY}/Themes/Silver.theme
	doins -r Resources Theme.bundle
}

pkg_postinst() {
	elog "Use gnustep-apps/systempreferences to switch theme"
}
