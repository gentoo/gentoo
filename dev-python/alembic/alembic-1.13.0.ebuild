# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Database migrations tool, written by the author of SQLAlchemy"
HOMEPAGE="
	https://github.com/sqlalchemy/alembic/
	https://pypi.org/project/alembic/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64 ~riscv x86"
IUSE="doc"

RDEPEND="
	>=dev-python/sqlalchemy-1.1.0[${PYTHON_USEDEP}]
	dev-python/mako[${PYTHON_USEDEP}]
	>=dev-python/python-editor-0.3[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4[${PYTHON_USEDEP}]
"

EPYTEST_XDIST=1
distutils_enable_tests pytest

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	# setup.cfg contains -p no:warnings in addopts which triggers
	# datetime.utcfromtimestamp() deprecation warning as an error in py3.12
	epytest -o addopts=
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/. )
	distutils-r1_python_install_all
}
