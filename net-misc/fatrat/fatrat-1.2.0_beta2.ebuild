# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="Qt4-based download/upload manager"
HOMEPAGE="http://fatrat.dolezel.info/"
SRC_URI="http://www.dolezel.info/download/data/${PN}/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bittorrent +curl doc xmpp nls webinterface"

RDEPEND="dev-qt/qtdbus:4
	dev-qt/qtgui:4
	dev-qt/qtsvg:4
	bittorrent? ( >=net-libs/rb_libtorrent-0.14.5
			>=dev-cpp/asio-1.1.0
			dev-qt/qtwebkit:4 )
	curl? ( >=net-misc/curl-7.18.2 )
	doc? ( dev-qt/qthelp:4 )
	xmpp? ( net-libs/gloox )
	webinterface? ( dev-qt/qtscript:4 )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}/${P}-build.patch"
	"${FILESDIR}/${P}-libcrypto_linking.patch"
)

src_configure() {
		local mycmakeargs="
			$(cmake-utils_use_with bittorrent) \
			$(cmake-utils_use_with curl) \
			$(cmake-utils_use_with doc DOCUMENTATION) \
			$(cmake-utils_use_with xmpp JABBER) \
			$(cmake-utils_use_with nls) \
			$(cmake-utils_use_with webinterface)"
		cmake-utils_src_configure
}

src_install() {
	use bittorrent && echo "MimeType=application/x-bittorrent;" >> "${S}"/data/${PN}.desktop
	cmake-utils_src_install
}

pkg_postinst() {
	# this is a completely optional and NOT automagic dep
	if ! has_version dev-libs/geoip; then
		elog "If you want the GeoIP support, then emerge dev-libs/geoip."
	fi
}
