# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic qmake-utils xdg

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
	dev-qt/qtdeclarative:5
	webengine? ( dev-qt/qtwebengine:5[widgets] )
"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	ebegin 'Sedding pri/install.pri to install to $(get_libdir)'
	if grep -q 'lib.path = $$quote($$PREFIX/lib/)' pri/install.pri; then
		sed -i \
			-e 's:lib.path = $$quote($$PREFIX/lib/):lib.path = $$quote($$PREFIX/'$(get_libdir)'/):' \
			pri/install.pri || die
		eend
	else
		eend 1
		eerror 'grep for lib.path = $$quote($$PREFIX/lib/) failed'
		die 'find out what changed and update the ebuild'
	fi
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
