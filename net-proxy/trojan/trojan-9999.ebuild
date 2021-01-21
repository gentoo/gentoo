# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
EGIT_REPO_URI="https://github.com/trojan-gfw/trojan.git"

inherit cmake git-r3 python-any-r1 systemd

DESCRIPTION="An unidentifiable mechanism that helps you bypass GFW"
HOMEPAGE="https://github.com/trojan-gfw/trojan"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS=""
IUSE="mysql test"

# Some hiccups setting up local network server.
RESTRICT="test"

RDEPEND="
	>=dev-libs/boost-1.66.0:=
	dev-libs/openssl:0=
	mysql? ( dev-db/mysql-connector-c:= )
"
DEPEND="${RDEPEND}
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

pkg_postinst() {
	elog "Running Trojan with multi instances"
	elog ""

	elog "Prepare /etc/trojan/\${blah}.json first"
	elog "Config with Openrc"
	elog "   ln -s /etc/init.d/trojan{,.\${blah}}"
	elog "   rc-update add trojan.\${blah} default"
	elog ""
	elog "Config with Systemd"
	elog "   systemctl enable trojan.\${blah}"
	elog ""
}
