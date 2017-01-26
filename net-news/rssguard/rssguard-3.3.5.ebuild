# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit qmake-utils

DESCRIPTION="A tiny RSS and Atom feed reader"
HOMEPAGE="https://github.com/martinrotter/rssguard"
SRC_URI="https://github.com/martinrotter/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug +webengine"

RDEPEND="
	>=dev-qt/qtcore-5.6:5
	>=dev-qt/qtgui-5.6:5
	>=dev-qt/qtnetwork-5.6:5
	>=dev-qt/qtsql-5.6:5
	>=dev-qt/qtwidgets-5.6:5
	>=dev-qt/qtxml-5.6:5
	webengine? ( >=dev-qt/qtwebengine-5.6:5[widgets] )
"
DEPEND="${RDEPEND}
	>=dev-qt/linguist-tools-5.6:5
"

PATCHES=( "${FILESDIR}/${P}-deps.patch" )

src_prepare() {
	default

	# remove bundled qtbase translations
	rm localization/qtbase* || die
	sed -i -e "s|localization/qtbase-[a-z][a-z].ts||g" ${PN}.pro || die
}

src_configure() {
	eqmake5 \
		CONFIG+=$(usex debug debug release) \
		USE_WEBENGINE=$(usex webengine true false) \
		LRELEASE_EXECUTABLE="$(qt5_get_bindir)/lrelease" \
		PREFIX="${EPREFIX}"/usr \
		INSTALL_ROOT=.
}

src_install() {
	emake install INSTALL_ROOT="${D}"
}
