# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/mpck/mpck-0.15.ebuild,v 1.3 2009/06/30 08:32:23 fauli Exp $

MY_P=checkmate-${PV}

DESCRIPTION="Checks MP3s for errors"
HOMEPAGE="http://mpck.linuxonly.nl/"
SRC_URI="http://checkmate.linuxonly.nl/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

S=${WORKDIR}/${MY_P}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ABOUT_FIXING AUTHORS ChangeLog HISTORY README
}
