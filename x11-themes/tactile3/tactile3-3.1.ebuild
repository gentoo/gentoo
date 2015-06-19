# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/tactile3/tactile3-3.1.ebuild,v 1.2 2012/12/02 11:33:39 hwoarang Exp $

EAPI=4

MY_PN="Tactile3"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="The third evolution of Tactile theme series"
HOMEPAGE="http://gnome-look.org/content/show.php/Tactile3?content=111845"
SRC_URI="http://gnome-look.org/CONTENT/content-files/111845-${MY_PN}.tar.gz"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="x11-themes/hicolor-icon-theme"

S="${WORKDIR}"/${MY_PN}

src_install() {
	insinto /usr/share/themes/
	doins -r "${S}"/
}
