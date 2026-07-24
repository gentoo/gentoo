# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{11..15} )

inherit distutils-r1

DESCRIPTION="PostgreSQL Workload Analyzer Collector"
HOMEPAGE="https://github.com/powa-team/powa-collector"
SRC_URI="https://github.com/powa-team/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="POSTGRESQL"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/psycopg:2[${PYTHON_USEDEP}]"

RESTRICT="test"

python_install_all() {
	distutils-r1_python_install_all

	insinto /etc
	newins powa-collector.conf-dist powa-collector.conf
}
