# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils qmake-utils

DESCRIPTION="An ancient boardgame, very common in Japan, China and Korea"
HOMEPAGE="http://qgo.sourceforge.net/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qttest:4
	media-libs/alsa-lib"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-gcc45.patch
	"${FILESDIR}"/${P}-qt47.patch
	"${FILESDIR}"/${P}-buffer.patch
)

src_prepare() {
	default
	sed -i \
		-e 's:$(QTDIR)/bin/lrelease:lrelease:' \
		src/src.pro || die
}

src_configure() {
	eqmake4 qgo2.pro
}

src_install() {
	emake install INSTALL_ROOT="${D}"

	dodoc AUTHORS

	insinto /usr/share/${PN}/languages
	doins src/translations/*.qm
}
