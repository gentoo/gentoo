# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
PYTHON_COMPAT=( python3_{9..10} )

inherit distutils-r1

DESCRIPTION="Realtime PostgreSQL database server monitoring tool"
HOMEPAGE="https://github.com/dalibo/pg_activity"
SRC_URI="https://github.com/dalibo/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"
SLOT="0"
LICENSE="POSTGRESQL"

RDEPEND="
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/blessed[${PYTHON_USEDEP}]
	dev-python/humanize[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
"

BDEPEND="
	dev-python/attrs[${PYTHON_USEDEP}]
	test? (
		dev-python/psycopg:0[${PYTHON_USEDEP}]
		dev-python/psycopg:2[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	# https://github.com/dalibo/pg_activity/issues/201
	export COLUMNS="80"
	epytest -k 'not test_ui.txt and not test_data.py'
}

src_install() {
	distutils-r1_src_install
	doman docs/man/${PN}.1
}
