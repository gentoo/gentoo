# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

DESCRIPTION="Cross-platform Direct Connect client"
HOMEPAGE="https://github.com/airdcpp-web/airdcpp-webclient"
SRC_URI="https://github.com/airdcpp-web/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2"
SLOT="0"
IUSE="+webui"

RDEPEND="
	dev-libs/geoip
	app-arch/bzip2
	sys-libs/zlib
	dev-libs/openssl:0
	dev-cpp/tbb
	virtual/libiconv
	net-libs/miniupnpc
	dev-libs/leveldb
	dev-cpp/websocketpp
	dev-libs/boost
"
DEPEND="
	net-libs/nodejs
	${RDEPEND}
"
PDEPEND="webui? ( www-apps/airdcpp-webui )"

src_configure() {
	local mycmakeargs=(
		-DINSTALL_WEB_UI=OFF
		-DLIB_INSTALL_DIR=$(get_libdir)
	)
	cmake-utils_src_configure
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		elog "Run 'airdcppd --configure' to set up ports and authentication"
	fi
}
