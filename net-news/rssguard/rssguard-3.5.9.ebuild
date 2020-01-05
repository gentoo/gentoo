# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic qmake-utils

DESCRIPTION="Tiny RSS and Atom feed reader"
HOMEPAGE="https://github.com/martinrotter/rssguard"
SRC_URI="https://github.com/martinrotter/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug webengine"

BDEPEND="dev-qt/linguist-tools:5"
DEPEND="
	dev-qt/qtconcurrent:5
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtsql:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	webengine? ( dev-qt/qtwebengine:5[widgets] )
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-qt-5.14.patch" )

src_configure() {
	# CONFIG+=ltcg is needed because of https://github.com/martinrotter/rssguard/issues/156
	eqmake5 \
		CONFIG+=$(usex debug debug release) \
		$(is-flagq -flto* && echo "CONFIG+=ltcg") \
		USE_WEBENGINE=$(usex webengine) \
		PREFIX="${EPREFIX}"/usr \
		INSTALL_ROOT=.
}

src_install() {
	emake install INSTALL_ROOT="${D}"
}
