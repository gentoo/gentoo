# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/gargantuan-icon-theme/gargantuan-icon-theme-1.7.ebuild,v 1.1 2009/09/03 11:45:35 ssuominen Exp $

inherit gnome2-utils

DESCRIPTION="Gargantuan Icon Theme"
HOMEPAGE="http://www.gnome-look.org/content/show.php?content=24364"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="x11-themes/hicolor-icon-theme"
DEPEND="${RDEPEND}"

S=${WORKDIR}/gargantuan

src_install() {
	dodoc README || die
	rm -f index.theme~ index.theme.old icons/iconrc~ README || die
	insinto /usr/share/icons/gargantuan
	doins -r * || die
}

pkg_preinst() { gnome2_icon_savelist; }
pkg_postinst() { gnome2_icon_cache_update; }
pkg_postrm() { gnome2_icon_cache_update; }
