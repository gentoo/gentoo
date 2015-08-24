# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

MY_P="e16-themes-${PV}"
DESCRIPTION="all the official Enlightenment themes"
HOMEPAGE="https://www.enlightenment.org/"
SRC_URI="mirror://sourceforge/enlightenment/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE=""

RDEPEND="!x11-themes/etheme-BlueSteel
	!x11-themes/etheme-BrushedMetal-Tigert
	!x11-themes/etheme-Ganymede
	!x11-themes/etheme-ShinyMetal"

S=${WORKDIR}/${MY_P}

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc AUTHORS ChangeLog
}
