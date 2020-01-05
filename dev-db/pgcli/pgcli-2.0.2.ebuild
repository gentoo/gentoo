# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_6} )
inherit distutils-r1

DESCRIPTION="CLI for Postgres with auto-completion and syntax highlighting"
HOMEPAGE="https://www.pgcli.com https://github.com/dbcli/pgcli"
SRC_URI="https://github.com/dbcli/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	<dev-python/prompt_toolkit-2.1.0[${PYTHON_USEDEP}]
	<dev-python/psycopg-2.8[${PYTHON_USEDEP}]
	<dev-python/python-sqlparse-0.3.0[${PYTHON_USEDEP}]
	>=dev-python/cli_helpers-1.0.1[${PYTHON_USEDEP}]
	>=dev-python/click-4.1[${PYTHON_USEDEP}]
	>=dev-python/configobj-5.0.6[${PYTHON_USEDEP}]
	>=dev-python/humanize-0.5.1[${PYTHON_USEDEP}]
	>=dev-python/keyring-12.2.0[${PYTHON_USEDEP}]
	>=dev-python/pgspecial-1.11.5[${PYTHON_USEDEP}]
	>=dev-python/prompt_toolkit-2.0.6[${PYTHON_USEDEP}]
	>=dev-python/psycopg-2.7.4[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.0[${PYTHON_USEDEP}]
	>=dev-python/python-sqlparse-0.2.2[${PYTHON_USEDEP}]
	>=dev-python/setproctitle-1.1.9[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
"
