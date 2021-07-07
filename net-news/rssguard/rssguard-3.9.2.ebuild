# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic qmake-utils xdg

DESCRIPTION="Tiny RSS and Atom feed reader"
HOMEPAGE="https://github.com/martinrotter/rssguard"
SRC_URI="https://github.com/martinrotter/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( LGPL-3 GPL-2+ ) AGPL-3+ BSD GPL-3+ MIT"
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
	dev-qt/qtdeclarative:5
	webengine? ( dev-qt/qtwebengine:5[widgets] )
"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	sed -e 's:lib.path = $$quote($$PREFIX/lib/):lib.path = $$quote($$PREFIX/'$(get_libdir)'/):' \
		-i pri/install.pri || die
}

src_configure() {
	# CONFIG+=ltcg is needed because of https://github.com/martinrotter/rssguard/issues/156
	eqmake5 \
		CONFIG+=$(usex debug debug release) \
		$(is-flagq -flto* && echo "CONFIG+=ltcg") \
		USE_WEBENGINE=$(usex webengine true false) \
		PREFIX="${EPREFIX}"/usr \
		INSTALL_ROOT=.
}

src_install() {
	emake -j1 install INSTALL_ROOT="${D}"
}
