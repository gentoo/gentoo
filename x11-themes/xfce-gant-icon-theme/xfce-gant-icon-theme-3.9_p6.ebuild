# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/xfce-gant-icon-theme/xfce-gant-icon-theme-3.9_p6.ebuild,v 1.3 2010/11/07 17:42:02 ssuominen Exp $

inherit gnome2-utils

DESCRIPTION="Xfce Gant Icon Theme"
HOMEPAGE="http://www.xfce-look.org/content/show.php/GANT?content=23297"
SRC_URI="http://overlay.uberpenguin.net/icons-xfce-gant-${PV/_p/-}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="x11-themes/hicolor-icon-theme"
DEPEND="${RDEPEND}"

RESTRICT="binchecks strip"

S=${WORKDIR}/Gant.Xfce

src_install() {
	dodoc README || die
	rm -f icons/iconrc~ README || die
	insinto /usr/share/icons/Gant.Xfce
	doins -r * || die
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
