# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/flatsvg/flatsvg-1.0.ebuild,v 1.8 2010/02/24 14:51:47 ssuominen Exp $

DESCRIPTION="Flat SVG icon set"
SRC_URI="http://www.atqu23.dsl.pipex.com/danny/flatSVG${PV}.tar.gz"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=17158"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 sparc x86 ~x86-fbsd"
IUSE=""

S=${WORKDIR}/FlatSVG

src_install() {
	dodir /usr/share/icons
	cp -rf "${S}" "${D}/usr/share/icons/FlatSVG"
}
