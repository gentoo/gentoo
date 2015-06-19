# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-geosciences/harmonics-dwf-free-noncomm/harmonics-dwf-free-noncomm-20111230-r1.ebuild,v 1.4 2014/08/10 20:27:50 slyfox Exp $

EAPI=5

MY_P="${P/-free-noncomm-/-}"
DESCRIPTION="Tidal harmonics database for libtcd"
HOMEPAGE="http://www.flaterco.com/xtide/"
# Even though the SRC_URI is labeled nonfree, the data is actually available for
# any non-commercial use.
SRC_URI="ftp://ftp.flaterco.com/xtide/${MY_P}-nonfree.tar.bz2"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

S=${WORKDIR}

src_install() {
	insinto /usr/share/harmonics
	doins "${WORKDIR}/${MY_P}"-nonfree.tcd
}
