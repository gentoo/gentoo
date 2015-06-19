# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/noia/noia-1.0-r1.ebuild,v 1.8 2009/06/11 09:42:34 scarabeus Exp $

DESCRIPTION="The Noia icon theme"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=3883"
SRC_URI="mirror://debian/pool/main/k/kde-icons-noia/kde-icons-noia_1.0.orig.tar.gz"

KEYWORDS="amd64 ppc sparc x86 ~x86-fbsd"
SLOT="0"
IUSE=""
LICENSE="LGPL-2.1"

S="${WORKDIR}/noia_kde_100"

RESTRICT="binchecks strip"

src_install() {
	insinto /usr/share/icons/${PN}
	doins -r .
}
