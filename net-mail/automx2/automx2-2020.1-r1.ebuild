# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )

inherit distutils-r1

DESCRIPTION="Email client autoconfiguration service"
HOMEPAGE="https://automx.org/"
SRC_URI="https://gitlab.com/automx/automx2/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64"
IUSE="doc"

BDEPEND="acct-user/automx2
	dev-python/flask-migrate[${PYTHON_USEDEP}]
	dev-python/ldap3[${PYTHON_USEDEP}]"
RDEPEND="${BDEPEND}"

python_prepare_all() {
	sed -i -e "/('scripts'/d" setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	export AUTOMX2_CONF="tests/unittest.conf"
	${EPYTHON} -m unittest discover tests/ || die
}

python_install_all() {
	if use doc; then
		DOCS="*.adoc doc/*.adoc contrib/*sample.conf"
		HTML_DOCS="doc/*.html doc/*.svg"
	fi
	sed -e "s/@EPYTHON@/${EPYTHON}/" "${FILESDIR}/init" | newinitd - "${PN}"
	newconfd "${FILESDIR}/confd" "${PN}"
	insinto /etc
	newins "${FILESDIR}/conf" "${PN}.conf"
	distutils-r1_python_install_all
}
