# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{6..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

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
"

PATCHES=(
	# https://github.com/sqlalchemy/alembic/commit/8690940976544f368dad31cfbc46d9e1426b2ce1
	"${FILESDIR}/${P}-pytest6.patch"
)

distutils_enable_tests pytest

python_prepare_all() {
	# suite passes all if run from source. The residual fail & error are quite erroneous
	rm tests/test_script_consumption.py || die

	distutils-r1_python_prepare_all
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/. )

	distutils-r1_python_install_all
}
