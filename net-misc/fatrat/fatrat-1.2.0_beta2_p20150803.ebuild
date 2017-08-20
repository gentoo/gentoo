# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

SNAPSHOT="b5be2b17ee291f6253484ec749037bc2c9200ccc"

inherit cmake-utils

DESCRIPTION="Qt4-based download/upload manager"
HOMEPAGE="http://fatrat.dolezel.info/"
if [[ -n "${SNAPSHOT}" ]] ; then
	SRC_URI="https://github.com/LubosD/fatrat/tarball/${SNAPSHOT} -> ${P}.tar.gz"
	S="${WORKDIR}/LubosD-${PN}-${SNAPSHOT:0:7}"
else
	SRC_URI="http://www.dolezel.info/download/data/${PN}/${P}.tar.xz"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bittorrent +curl doc xmpp nls webinterface"

RDEPEND="dev-qt/qtdbus:4
	dev-qt/qtgui:4
	dev-qt/qtsvg:4
	bittorrent? (
		>=net-libs/libtorrent-rasterbar-0.14.5
		>=dev-cpp/asio-1.1.0
		dev-qt/qtwebkit:4
	)
	curl? ( >=net-misc/curl-7.18.2 )
	doc? ( dev-qt/qthelp:4 )
	xmpp? ( net-libs/gloox )
	webinterface? ( dev-qt/qtscript:4 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}/${P}-build.patch"
)

src_configure() {
		local mycmakeargs=(
			-DWITH_BITTORRENT="$(usex bittorrent ON OFF)"
			-DWITH_CURL="$(usex curl ON OFF)"
			-DWITH_DOCUMENTATION="$(usex doc ON OFF)"
			-DWITH_JABBER="$(usex xmpp ON OFF)"
			-DWITH_NLS="$(usex nls ON OFF)"
			-DWITH_WEBINTERFACE="$(usex webinterface ON OFF)"
		)
		cmake-utils_src_configure
}

pkg_postinst() {
	# this is a completely optional and NOT automagic dep
	if ! has_version dev-libs/geoip; then
		elog "If you want GeoIP support, emerge dev-libs/geoip."
	fi
}
