# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=(python3_{11..13})

inherit distutils-r1

DESCRIPTION="Mail User Agent (email client) configuration made easy"
HOMEPAGE="https://rseichter.github.io/automx2/"
SRC_URI="https://github.com/rseichter/automx2/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="acct-user/automx2
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/flask-migrate[${PYTHON_USEDEP}]
	dev-python/flask-sqlalchemy[${PYTHON_USEDEP}]
	dev-python/ldap3[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest

python_prepare_all() {
	rm -r src/alembic || die
	distutils-r1_python_prepare_all
}

python_test() {
	local -x AUTOMX2_CONF="tests/unittest.conf"
	eunittest tests/
}

python_install_all() {
	local DOCS=("${S}"/docs/*.pdf)
	local HTML_DOCS=("${S}"/docs/*.{html,svg})
	newconfd "${FILESDIR}/confd" "${PN}"
	newinitd "${FILESDIR}/init-r2" "${PN}"
	insinto /etc
	newins "${FILESDIR}/conf" "${PN}.conf"
	distutils-r1_python_install_all
}
