# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/DFBPoint/DFBPoint-0.7.2.ebuild,v 1.17 2014/06/22 09:40:13 pacho Exp $

EAPI=5
inherit gnome2-utils

DESCRIPTION="DFBPoint is presentation program based on DirectFB"
HOMEPAGE="http://www.directfb.org/index.php?path=Projects%2FDFBPoint"
SRC_URI="http://www.directfb.org/download/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 -sparc x86"
IUSE=""

RDEPEND="
	dev-libs/DirectFB
	>=dev-libs/glib-2:2
"
DEPEND="${RDEPEND}
	>=dev-libs/glib-2
"

src_prepare() {
	gnome2_disable_deprecation_warning
}

src_install () {
	default

	dodir /usr/share/DFBPoint/
	cp dfbpoint.dtd "${D}"/usr/share/DFBPoint/

	dodoc AUTHORS ChangeLog INSTALL README NEWS

	dodir /usr/share/DFBPoint/examples/
	cd examples
	cp bg.png bullet.png decker.ttf test.xml wilber_stoned.png \
		"${D}"/usr/share/DFBPoint/examples/
	cp -R guadec/ "${D}"/usr/share/DFBPoint/examples/
}
