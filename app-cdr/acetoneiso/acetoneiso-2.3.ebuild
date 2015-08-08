# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
MY_P=${PN}_${PV}

inherit flag-o-matic qt4-r2

DESCRIPTION="a feature-rich and complete software application to manage CD/DVD images"
HOMEPAGE="http://sourceforge.net/projects/${PN}/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="kde"

DEPEND="dev-qt/qtcore:4
	dev-qt/qtdbus:4
	dev-qt/qtgui:4
	dev-qt/qtwebkit:4
	kde? ( media-libs/phonon[qt4] )
	!kde? ( || ( dev-qt/qtphonon:4 media-libs/phonon[qt4] ) )"
RDEPEND="${DEPEND}
	sys-fs/fuseiso"

S=${WORKDIR}/${MY_P}/${PN}
DOCS=(../AUTHORS ../CHANGELOG ../FEATURES ../README)

src_prepare() {
	sed -i -e 's:unrar-nonfree:unrar:g' sources/compress.h locale/*.ts || die
	sed -i -e 's:include <Phonon/:include <:' sources/* || die "phonon sed failed"
}

src_configure() {
	append-cxxflags -I/usr/include/KDE/Phonon

	qt4-r2_src_configure
}
