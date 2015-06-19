# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/ladspa-bs2b/ladspa-bs2b-0.9.1.ebuild,v 1.3 2011/10/23 12:08:38 maekke Exp $

DESCRIPTION="LADSPA plugin for bs2b headphone filter"
HOMEPAGE="http://bs2b.sourceforge.net/"
SRC_URI="mirror://sourceforge/bs2b/LADSPA%20splugin/${PV}/${P}.tar.bz2"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="media-libs/ladspa-sdk
		>=media-libs/libbs2b-3.1.0"

RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS THANKS
}
