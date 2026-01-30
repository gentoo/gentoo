# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Database migrations tool, written by the author of SQLAlchemy"
HOMEPAGE="
	https://github.com/sqlalchemy/alembic/
	https://pypi.org/project/alembic/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"
IUSE="doc"

RDEPEND="
	>=dev-python/sqlalchemy-1.4.23[${PYTHON_USEDEP}]
	dev-python/mako[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.12[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		sys-libs/timezone-data
	)
"

EPYTEST_PLUGINS=()
EPYTEST_XDIST=1
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=()

	if ! has_version "dev-python/black[${PYTHON_USEDEP}]"; then
		EPYTEST_DESELECT+=(
			tests/test_post_write.py::RunHookTest::test_module
			tests/test_post_write.py::RunHookTest::test_module_black_with_cwd
			tests/test_post_write.py::RunHookTest::test_module_filename_interpolation
			tests/test_post_write.py::RunHookTest::test_module_path_in_config
		)
	fi

	# setup.cfg contains -p no:warnings in addopts which triggers
	# datetime.utcfromtimestamp() deprecation warning as an error in py3.12
	epytest -o addopts=
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/. )
	distutils-r1_python_install_all
}
