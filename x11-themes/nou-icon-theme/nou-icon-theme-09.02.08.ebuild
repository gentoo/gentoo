# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/nou-icon-theme/nou-icon-theme-09.02.08.ebuild,v 1.2 2010/11/10 14:37:18 ssuominen Exp $

inherit gnome2-utils versionator

MY_PV=$(delete_all_version_separators ${PV})

DESCRIPTION="A scalable icon theme called Nou"
HOMEPAGE="http://www.silvestre.com.ar/"
SRC_URI="http://www.silvestre.com.ar/icons/Nou-${MY_PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="minimal"

RDEPEND="!minimal? ( || ( x11-themes/tango-icon-theme x11-themes/gnome-icon-theme ) )"
DEPEND=""

RESTRICT="binchecks strip"

S=${WORKDIR}

src_install() {
	dodoc Nou/{AUTHORS,README}
	rm -f Nou/{AUTHORS,COPYING,DONATE,INSTALL,README,.icon-theme.cache}

	insinto /usr/share/icons
	doins -r Nou || die
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
