# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Email client autoconfiguration service"
HOMEPAGE="https://automx.org/"
SRC_URI="https://github.com/rseichter/automx2/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="acct-user/automx2
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/flask-migrate[${PYTHON_USEDEP}]
	dev-python/flask-sqlalchemy[${PYTHON_USEDEP}]
	dev-python/ldap3[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest

python_prepare_all() {
	sed -i -e "/('scripts'/d" setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	export AUTOMX2_CONF="tests/unittest.conf"
	${EPYTHON} -m unittest discover tests/ || die "Tests failed with ${EPYTHON}"
}

python_install_all() {
	local DOCS=( ${S}/docs/*.adoc ${S}/contrib/*sample.conf )
	local HTML_DOCS=( ${S}/docs/*.{html,svg} )
	newconfd "${FILESDIR}/confd" "${PN}"
	newinitd "${FILESDIR}/init-r1" "${PN}"
	insinto /etc
	newins "${FILESDIR}/conf" "${PN}.conf"
	distutils-r1_python_install_all
}
