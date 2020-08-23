# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

SNAPSHOT="14a1a146df76d70c44dcc38363848a5b41a364d5"
inherit cmake xdg-utils

DESCRIPTION="Qt5-based download/upload manager"
HOMEPAGE="http://fatrat.dolezel.info/"
SRC_URI="https://github.com/LubosD/fatrat/tarball/${SNAPSHOT} -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bittorrent +curl doc nls xmpp"

BDEPEND="
	dev-qt/linguist-tools:5
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"
RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtsvg:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	bittorrent? (
		dev-qt/qtwebengine:5[widgets]
		>=net-libs/libtorrent-rasterbar-1.1.1
	)
	curl? ( >=net-misc/curl-7.18.2 )
	doc? ( dev-qt/qthelp:5 )
	xmpp? ( net-libs/gloox )
"
DEPEND="${RDEPEND}
	dev-libs/boost
"

S="${WORKDIR}/LubosD-${PN}-14a1a14"

PATCHES=(
	"${FILESDIR}/${PN}-1.2.0_beta2_p20150803-build.patch"
	"${FILESDIR}/${P}-qt-5.15.patch"
)

src_configure() {
	local mycmakeargs=(
		-DWITH_BITTORRENT="$(usex bittorrent ON OFF)"
		-DWITH_CURL="$(usex curl ON OFF)"
		-DWITH_DOCUMENTATION="$(usex doc ON OFF)"
		-DWITH_NLS="$(usex nls ON OFF)"
		-DWITH_JABBER="$(usex xmpp ON OFF)"
		-DWITH_WEBINTERFACE=OFF
	)
	cmake_src_configure
}

pkg_postinst() {
	# optional runtime dep
	if ! has_version dev-libs/geoip; then
		elog "If you want GeoIP support, emerge dev-libs/geoip."
	fi

	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}
