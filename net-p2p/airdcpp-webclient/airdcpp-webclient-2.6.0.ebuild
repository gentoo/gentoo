# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( pypy3 python{2_7,3_{6,7}} )

inherit cmake-utils python-any-r1 user

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
	dev-libs/leveldb:=
	dev-libs/libmaxminddb:=
	dev-libs/openssl:0=[-bindist]
	net-libs/miniupnpc:=
	sys-libs/zlib:=
	virtual/libiconv
	nat-pmp? ( net-libs/libnatpmp:= )
	tbb? ( dev-cpp/tbb:= )
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
		-DENABLE_NATPMP=$(usex nat-pmp)
		-DENABLE_TBB=$(usex tbb)
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	newconfd "${FILESDIR}/airdcppd.confd" airdcppd
	newinitd "${FILESDIR}/airdcppd.initd" airdcppd
	keepdir /var/lib/airdcppd
	fowners airdcppd:airdcppd /var/lib/airdcppd
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		elog "Run 'airdcppd --configure' to set up ports and authentication"
	fi
}
