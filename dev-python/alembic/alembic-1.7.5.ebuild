# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( pypy3 python3_{8..10} )
inherit distutils-r1

DESCRIPTION="database migrations tool, written by the author of SQLAlchemy"
HOMEPAGE="https://github.com/sqlalchemy/alembic"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="doc"

RDEPEND="
	>=dev-python/sqlalchemy-1.1.0[${PYTHON_USEDEP}]
	dev-python/mako[${PYTHON_USEDEP}]
	>=dev-python/python-editor-0.3[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/importlib_metadata[${PYTHON_USEDEP}]
		dev-python/importlib_resources[${PYTHON_USEDEP}]
	' pypy3 python3_8)
"

distutils_enable_tests pytest

python_install_all() {
	use doc && local HTML_DOCS=( docs/. )

	distutils-r1_python_install_all
}
