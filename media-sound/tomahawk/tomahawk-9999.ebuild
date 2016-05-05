# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde5

if [[ ${KDE_BUILD_TYPE} != live ]]; then
	SRC_URI="http://download.tomahawk-player.org/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
else
	EGIT_REPO_URI="git://github.com/tomahawk-player/${PN}.git"
fi

DESCRIPTION="Multi-source social music player"
HOMEPAGE="http://tomahawk-player.org/"

LICENSE="GPL-3 BSD"
SLOT="0"
IUSE="+hatchet telepathy xmpp"

CDEPEND="
	$(add_frameworks_dep attica)
	$(add_qt_dep designer)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtsql)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwebkit)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtx11extras)
	$(add_qt_dep qtxml)
	app-crypt/qca:2[qt5]
	dev-cpp/lucene++
	dev-cpp/sparsehash
	dev-libs/boost:=
	dev-libs/qtkeychain[qt5]
	dev-libs/quazip[qt5]
	>=media-libs/libechonest-2.3.1:=[qt5]
	media-libs/liblastfm[qt5]
	>=media-libs/taglib-1.8.0
	media-video/vlc:=[flac,dvbpsi,ffmpeg,mp3]
	>=net-libs/gnutls-3.2
	x11-libs/libX11
	hatchet? ( dev-cpp/websocketpp )
	telepathy? ( net-libs/telepathy-qt[qt5] )
	xmpp? ( net-libs/jreen[qt5] )
"
DEPEND="${CDEPEND}
	$(add_qt_dep linguist-tools)
	$(add_qt_dep qtconcurrent)
"
RDEPEND="${CDEPEND}
	app-crypt/qca:2[openssl]
"

DOCS=( AUTHORS ChangeLog README.md )

PATCHES=(
	"${FILESDIR}/${PN}-quazip-cmake.patch"
	"${FILESDIR}/${PN}-liblastfm-cmake.patch"
)

src_configure() {
	local mycmakeargs=(
		-DWITH_CRASHREPORTER=OFF
		-DBUILD_TESTS=OFF
		-DBUILD_TOOLS=OFF
		-DBUILD_WITH_QT4=OFF
		-DWITH_KDE4=OFF
		-DBUILD_HATCHET=$(usex hatchet)
		-DWITH_TelepathyQt=$(usex telepathy)
		-DWITH_Jreen=$(usex xmpp)
	)

	if [[ ${KDE_BUILD_TYPE} != live ]]; then
		mycmakeargs+=( -DBUILD_RELEASE=ON )
	fi

	kde5_src_configure
}
