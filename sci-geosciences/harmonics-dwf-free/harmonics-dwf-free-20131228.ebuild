# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MY_P="${P/-free-/-}"
DESCRIPTION="Tidal harmonics database for libtcd"
HOMEPAGE="http://www.flaterco.com/xtide/"
SRC_URI="ftp://ftp.flaterco.com/xtide/${MY_P}-free.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

S=${WORKDIR}/${MY_P}

src_install() {
	insinto /usr/share/harmonics
	doins "${MY_P}"-free.tcd
	dodoc ChangeLog
}
