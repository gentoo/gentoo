# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
inherit distutils-r1

DESCRIPTION="CLI for Postgres with auto-completion and syntax highlighting"
HOMEPAGE="https://www.pgcli.com https://github.com/dbcli/pgcli"
SRC_URI="https://github.com/dbcli/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-python/prompt_toolkit-2.0.6[${PYTHON_USEDEP}]
	<dev-python/prompt_toolkit-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/psycopg-2.8.0[${PYTHON_USEDEP}]
	>=dev-python/python-sqlparse-0.3.0[${PYTHON_USEDEP}]
	<dev-python/python-sqlparse-0.4.0[${PYTHON_USEDEP}]
	>=dev-python/cli_helpers-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/click-4.1[${PYTHON_USEDEP}]
	>=dev-python/configobj-5.0.6[${PYTHON_USEDEP}]
	>=dev-python/humanize-0.5.1[${PYTHON_USEDEP}]
	>=dev-python/pgspecial-1.11.8[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.0[${PYTHON_USEDEP}]
	>=dev-python/setproctitle-1.1.9[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

BDEPEND="
	test? (
		dev-db/postgresql
		dev-python/mock[${PYTHON_USEDEP}]
	)
"

# there is a flaky test, so no tests for now
RESTRICT="test"

distutils_enable_tests pytest
