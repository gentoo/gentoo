# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{3_6,3_7} )

inherit cmake-utils python-any-r1 systemd

DESCRIPTION="An unidentifiable mechanism that helps you bypass GFW"
HOMEPAGE="https://github.com/trojan-gfw/${PN}"
SRC_URI="https://github.com/trojan-gfw/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="mysql test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/boost-1.54.0:=
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
		-DCMAKE_INSTALL_DOCDIR=share/doc/${PF}
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	newinitd "${FILESDIR}/trojan.initd" trojan
}

src_test() {
	cmake-utils_src_test -j1
}
