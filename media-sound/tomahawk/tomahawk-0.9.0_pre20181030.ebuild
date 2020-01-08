# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

COMMIT=777b31219179b43f56c7b95857d2fbd7f33199aa
inherit cmake-utils xdg-utils

DESCRIPTION="Multi-source social music player"
HOMEPAGE="https://github.com/tomahawk-player/tomahawk"
SRC_URI="https://github.com/${PN}-player/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3 BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="telepathy xmpp"

COMMON_DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsql:5
	dev-qt/qtsvg:5
	dev-qt/qtwebkit:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	dev-qt/qtxml:5
	app-crypt/qca:2[qt5(+)]
	dev-cpp/lucene++
	dev-cpp/sparsehash
	dev-libs/boost:=
	dev-libs/qtkeychain:=[qt5(+)]
	>=dev-libs/quazip-0.7.2[qt5(+)]
	kde-frameworks/extra-cmake-modules:5
	kde-frameworks/attica:5
	>=media-libs/liblastfm-1.1.0_pre20150206
	>=media-libs/taglib-1.8.0
	media-video/vlc:=[flac,dvbpsi,ffmpeg,mp3]
	>=net-libs/gnutls-3.2:=
	x11-libs/libX11
	telepathy? ( >=net-libs/telepathy-qt-0.9.7-r1[qt5(+)] )
	xmpp? ( >=net-libs/jreen-1.3.0[qt5(+)] )
"
DEPEND="${COMMON_DEPEND}
	dev-qt/designer:5
	dev-qt/linguist-tools:5
	dev-qt/qtconcurrent:5
"
RDEPEND="${COMMON_DEPEND}
	app-crypt/qca:2[ssl]
"

S="${WORKDIR}/${PN}-${COMMIT}"

PATCHES=(
	"${FILESDIR}/${P}-fix-warning.patch"
	"${FILESDIR}/${P}-cmakepolicy.patch" # bug 674826
)

src_configure() {
	local mycmakeargs=(
		-DWITH_CRASHREPORTER=OFF
		-DBUILD_TESTS=OFF
		-DBUILD_TOOLS=OFF
		-DBUILD_HATCHET=OFF
		-DWITH_TelepathyQt=$(usex telepathy)
		-DWITH_Jreen=$(usex xmpp)
	)

	[[ ${PV} != *9999* ]] && mycmakeargs+=( -DBUILD_RELEASE=ON )

	cmake-utils_src_configure
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
