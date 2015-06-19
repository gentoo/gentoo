# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/Tulliana/Tulliana-2.0.ebuild,v 1.6 2007/07/12 07:35:24 mr_bones_ Exp $

DESCRIPTION="Tulliana icon set for KDE"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=38757"
SRC_URI="http://cekirdek.pardus.org.tr/~caglar/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86 ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND=""

RESTRICT="strip binchecks"

src_install() {
	insinto /usr/share/icons/${PN}
	doins -r .
}
