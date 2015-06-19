# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/fvwm-themes-extra/fvwm-themes-extra-0.7.0.ebuild,v 1.14 2011/11/11 17:19:12 ssuominen Exp $

DESCRIPTION="Extra themes for fvwm-themes"
HOMEPAGE="http://fvwm-themes.sourceforge.net/"
SRC_URI="mirror://sourceforge/fvwm-themes/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 ~sparc x86"
IUSE=""

RDEPEND="x11-themes/fvwm-themes"
DEPEND=""

src_install() {
	mkdir -p "${D}"/usr/share/fvwm/themes/
	cp -r "${S}"/* "${D}"/usr/share/fvwm/themes/
}
