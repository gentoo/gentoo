# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit flag-o-matic qmake-utils

DESCRIPTION="A tiny RSS and Atom feed reader"
HOMEPAGE="https://github.com/martinrotter/rssguard"
SRC_URI="https://github.com/martinrotter/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug webengine"
MINQT="5.8:5"

RDEPEND="
	>=dev-qt/qtcore-${MINQT}
	>=dev-qt/qtgui-${MINQT}
	>=dev-qt/qtnetwork-${MINQT}
	>=dev-qt/qtconcurrent-${MINQT}
	>=dev-qt/qtsql-${MINQT}
	>=dev-qt/qtwidgets-${MINQT}
	>=dev-qt/qtxml-${MINQT}
	webengine? ( >=dev-qt/qtwebengine-${MINQT}[widgets] )
"
DEPEND="${RDEPEND}
	>=dev-qt/linguist-tools-${MINQT}
"

src_configure() {
	# needed after 8eb640b6f2e140e7c5a1adbe5532cf3662d850b5
	"$(qt5_get_bindir)/lrelease" rssguard.pro || die "lrelease failed"
	# CONFIG+=ltcg is needed because of https://github.com/martinrotter/rssguard/issues/156
	eqmake5 \
		CONFIG+=$(usex debug debug release) \
		$(is-flagq -flto* && echo "CONFIG+=ltcg") \
		USE_WEBENGINE=$(usex webengine true false) \
		LRELEASE_EXECUTABLE="$(qt5_get_bindir)/lrelease" \
		PREFIX="${EPREFIX}"/usr \
		INSTALL_ROOT=.
}

src_install() {
	emake install INSTALL_ROOT="${D}"
}
