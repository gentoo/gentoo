# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_5,3_6,3_7} )

inherit cmake python-any-r1 systemd

DESCRIPTION="An unidentifiable mechanism that helps you bypass GFW"
HOMEPAGE="https://github.com/trojan-gfw/${PN}"
SRC_URI="https://github.com/trojan-gfw/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="mysql test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/boost-1.66.0:=
	>=dev-libs/openssl-1.0.2:=
	mysql? ( dev-db/mysql-connector-c:= )
"
DEPEND="
	${RDEPEND}
	test? ( net-misc/curl ${PYTHON_DEPS} )
"

src_configure() {
	local mycmakeargs=(
		-DENABLE_MYSQL=$(usex mysql)
		-DSYSTEMD_SERVICE=ON
		-DSYSTEMD_SERVICE_PATH=$(systemd_get_systemunitdir)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	newinitd "${FILESDIR}/trojan.initd" trojan
}

src_test() {
	cmake_src_test -j1
}
