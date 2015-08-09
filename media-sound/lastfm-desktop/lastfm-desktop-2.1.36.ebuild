# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit qt4-r2

DESCRIPTION="The official Last.fm desktop application suite"
HOMEPAGE="http://www.last.fm https://github.com/lastfm/lastfm-desktop"
SRC_URI="https://github.com/lastfm/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	dev-qt/qtcore:4
	dev-qt/qtdbus:4
	dev-qt/qtgui:4
	dev-qt/qtsql:4
	dev-qt/qtwebkit:4
	media-libs/libgpod
	media-libs/liblastfm[fingerprint]
	sys-libs/zlib
	|| ( dev-qt/qtphonon:4 kde-apps/phonon-kde:4 )"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-missing-cast.patch )

src_configure() {
	eqmake4 Last.fm.pro PREFIX="${EPREFIX}"/usr
}
