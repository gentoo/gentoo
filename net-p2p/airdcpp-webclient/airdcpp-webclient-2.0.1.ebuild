# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5} pypy{,3} )

inherit cmake-utils user python-any-r1

DESCRIPTION="Cross-platform Direct Connect client"
HOMEPAGE="https://airdcpp-web.github.io/"
SRC_URI="https://github.com/airdcpp-web/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
LICENSE="GPL-2+"
SLOT="0"
IUSE="nat-pmp +tbb +webui"

RDEPEND="
	app-arch/bzip2
	dev-cpp/websocketpp
	dev-libs/boost:=
	dev-libs/geoip
	dev-libs/leveldb
	dev-libs/openssl:0=[-bindist]
	net-libs/miniupnpc:=
	sys-libs/zlib
	virtual/libiconv
	nat-pmp? ( net-libs/libnatpmp )
	tbb? ( dev-cpp/tbb )
"
DEPEND="
	virtual/pkgconfig
	${PYTHON_DEPS}
	${RDEPEND}
"
PDEPEND="webui? ( www-apps/airdcpp-webui )"

pkg_setup() {
	python-any-r1_pkg_setup
	enewgroup airdcppd
	enewuser airdcppd -1 -1 /var/lib/airdcppd airdcppd
}

src_configure() {
	local mycmakeargs=(
		-DINSTALL_WEB_UI=OFF
	)
	cmake-utils_src_configure
}

src_install() {
	newconfd "${FILESDIR}/airdcppd.confd" airdcppd
	newinitd "${FILESDIR}/airdcppd.initd" airdcppd
	keepdir /var/lib/airdcppd
	fowners airdcppd:airdcppd /var/lib/airdcppd
	cmake-utils_src_install
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		elog "Run 'airdcppd --configure' to set up ports and authentication"
	fi
}
