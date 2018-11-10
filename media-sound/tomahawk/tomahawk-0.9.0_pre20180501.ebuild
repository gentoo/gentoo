# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

COMMIT=34c1f88171f00a3e9fae57250799f3d3623b5f74
inherit kde5 vcs-snapshot

DESCRIPTION="Multi-source social music player"
HOMEPAGE="https://www.tomahawk-player.org/"
SRC_URI="https://github.com/${PN}-player/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3 BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="telepathy xmpp"

CDEPEND="
	$(add_frameworks_dep attica)
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtgui)
	$(add_qt_dep qtnetwork)
	$(add_qt_dep qtsql)
	$(add_qt_dep qtsvg)
	$(add_qt_dep qtwebkit)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtx11extras)
	$(add_qt_dep qtxml)
	app-crypt/qca:2[qt5(+)]
	dev-cpp/lucene++
	dev-cpp/sparsehash
	dev-libs/boost:=
	dev-libs/qtkeychain:=[qt5(+)]
	>=dev-libs/quazip-0.7.2[qt5(+)]
	>=media-libs/liblastfm-1.1.0_pre20150206
	>=media-libs/taglib-1.8.0
	media-video/vlc:=[flac,dvbpsi,ffmpeg,mp3]
	>=net-libs/gnutls-3.2:=
	x11-libs/libX11
	telepathy? ( >=net-libs/telepathy-qt-0.9.7-r1[qt5(+)] )
	xmpp? ( >=net-libs/jreen-1.3.0[qt5(+)] )
"
DEPEND="${CDEPEND}
	$(add_qt_dep designer)
	$(add_qt_dep linguist-tools)
	$(add_qt_dep qtconcurrent)
"
RDEPEND="${CDEPEND}
	app-crypt/qca:2[ssl]
"

src_configure() {
	local mycmakeargs=(
		-DWITH_CRASHREPORTER=OFF
		-DBUILD_TESTS=OFF
		-DBUILD_TOOLS=OFF
		-DBUILD_WITH_QT4=OFF
		-DWITH_KDE4=OFF
		-DBUILD_HATCHET=OFF
		-DWITH_TelepathyQt=$(usex telepathy)
		-DWITH_Jreen=$(usex xmpp)
	)

	if [[ ${KDE_BUILD_TYPE} != live ]]; then
		mycmakeargs+=( -DBUILD_RELEASE=ON )
	fi

	kde5_src_configure
}
