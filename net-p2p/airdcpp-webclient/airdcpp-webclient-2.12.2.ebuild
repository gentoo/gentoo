# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( pypy3 python3_{10..13} )

inherit cmake python-any-r1 systemd

DESCRIPTION="Cross-platform Direct Connect client"
HOMEPAGE="https://airdcpp-web.github.io/"
SRC_URI="https://github.com/airdcpp-web/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE="debug nat-pmp +tbb +webui"

RDEPEND="
	acct-user/airdcppd
	acct-group/airdcppd
	app-arch/bzip2
	dev-cpp/websocketpp
	dev-libs/boost:=
	dev-libs/leveldb:=
	dev-libs/libmaxminddb:=
	dev-libs/openssl:0=[-bindist(-)]
	net-libs/miniupnpc:=
	sys-libs/zlib
	virtual/libiconv
	nat-pmp? ( net-libs/libnatpmp:= )
	tbb? ( dev-cpp/tbb:= )
"
DEPEND="
	dev-cpp/nlohmann_json
	${RDEPEND}
"
BDEPEND="
	virtual/pkgconfig
	${PYTHON_DEPS}
"
PDEPEND="webui? ( www-apps/airdcpp-webui )"

src_configure() {
	local mycmakeargs=(
		-DENABLE_NATPMP=$(usex nat-pmp)
		-DENABLE_TBB=$(usex tbb)
		-DINSTALL_WEB_UI=OFF
	)
	CMAKE_BUILD_TYPE=$(usex debug Debug RelWithDebInfo) cmake_src_configure
}

src_install() {
	cmake_src_install
	newconfd "${FILESDIR}/airdcppd.confd" airdcppd
	newinitd "${FILESDIR}/airdcppd.initd" airdcppd
	systemd_dounit "${FILESDIR}/airdcppd.service"
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		elog "Run 'airdcppd --configure' to set up ports and authentication"
	fi
}
