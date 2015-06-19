# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-geosciences/harmonics-dwf-free/harmonics-dwf-free-20131228.ebuild,v 1.1 2013/12/30 18:03:40 hasufell Exp $

EAPI=5

MY_P="${P/-free-/-}"
DESCRIPTION="Tidal harmonics database for libtcd"
HOMEPAGE="http://www.flaterco.com/xtide/"
SRC_URI="ftp://ftp.flaterco.com/xtide/${MY_P}-free.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/${MY_P}

src_install() {
	insinto /usr/share/harmonics
	doins "${MY_P}"-free.tcd
	dodoc ChangeLog
}
