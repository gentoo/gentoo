# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_REQUIRED="optional"
inherit kde4-base ${GIT_ECLASS}

if [[ ${PV} != *9999* ]]; then
	SRC_URI="http://download.tomahawk-player.org/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
else
	GIT_ECLASS="git-r3"
	EGIT_REPO_URI="git://github.com/tomahawk-player/${PN}.git"
	KEYWORDS=""
fi

DESCRIPTION="Multi-source social music player"
HOMEPAGE="http://tomahawk-player.org/"

LICENSE="GPL-3 BSD"
SLOT="0"
IUSE="debug +hatchet kde qt5 telepathy xmpp"

REQUIRED_USE="telepathy? ( kde )"

DEPEND="
	dev-cpp/lucene++
	dev-cpp/sparsehash
	dev-libs/boost:=
	>=media-libs/taglib-1.8.0
	>=net-libs/gnutls-3.2
	x11-libs/libX11
	hatchet? ( dev-cpp/websocketpp )
	xmpp? ( net-libs/jreen )
	!qt5? (
		app-crypt/qca:2[qt4(+)]
		>=dev-libs/libattica-0.4.0
		dev-libs/qjson
		dev-libs/qtkeychain[qt4]
		dev-libs/quazip[qt4]
		dev-qt/designer:4
		dev-qt/qtcore:4
		dev-qt/qtdbus:4
		dev-qt/qtgui:4
		dev-qt/qtsql:4[sqlite]
		dev-qt/qtsvg:4
		dev-qt/qtwebkit:4
		media-libs/phonon[qt4]
		>=media-libs/libechonest-2.3.1:=[qt4]
		media-libs/liblastfm[qt4]
		telepathy? ( net-libs/telepathy-qt[qt4] )
	)
	qt5? (
		app-crypt/qca:2[qt5(+)]
		dev-libs/qtkeychain[qt5]
		dev-libs/quazip[qt5]
		dev-qt/designer:5
		dev-qt/qtcore:5
		dev-qt/qtsvg:5
		dev-qt/qtwebkit:5
		dev-qt/qtwidgets:5
		kde-frameworks/attica:5
		media-libs/phonon[qt5]
		>=media-libs/libechonest-2.3.1:=[qt5]
		media-libs/liblastfm[qt5]
		telepathy? ( net-libs/telepathy-qt[qt5] )
	)
"
RDEPEND="${DEPEND}
	app-crypt/qca:2[openssl]
"

DOCS=( AUTHORS ChangeLog README.md )

PATCHES=(
	"${FILESDIR}/${P}-qt55.patch"
	"${FILESDIR}/${P}-taglib-1.10.patch"
	"${FILESDIR}/${P}-qca-qt5-linking.patch"
	"${FILESDIR}/${P}-echonest231.patch"
)

src_configure() {
	local mycmakeargs=(
		-DWITH_CRASHREPORTER=OFF
		$(cmake-utils_use_build hatchet)
		$(cmake-utils_use_with xmpp Jreen)
		$(cmake-utils_use_with kde KDE4)
		$(cmake-utils_use_build !qt5 WITH_QT4)
		$(cmake-utils_use_with telepathy TelepathyQt)
	)

	if [[ ${PV} != *9999* ]]; then
		mycmakeargs+=( -DBUILD_RELEASE=ON )
	fi

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
}
