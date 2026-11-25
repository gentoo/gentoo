# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{11..15} )

inherit distutils-r1 systemd

DESCRIPTION="PostgreSQL Workload Analyzer user interface"
HOMEPAGE="https://github.com/powa-team/powa-web"
SRC_URI="https://github.com/powa-team/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="POSTGRESQL"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	acct-group/powa
	acct-user/powa
	dev-python/psycopg:2[${PYTHON_USEDEP}]
	dev-python/tornado[${PYTHON_USEDEP}]
"

python_install_all() {
	distutils-r1_python_install_all

	insinto /etc
	newins powa-web.conf-dist powa-web.conf

	newinitd "${FILESDIR}/powa-web.initd" powa-web
	systemd_dounit "${FILESDIR}/powa-web.service"
}
