# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=pdm-backend
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Python package and dependency manager supporting the latest PEP standards"
HOMEPAGE="
	https://pdm-project.org/
	https://github.com/pdm-project/pdm/
	https://pypi.org/project/pdm/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	dev-python/certifi[${PYTHON_USEDEP}]
	>=dev-python/dep-logic-0.5[${PYTHON_USEDEP}]
	<dev-python/findpython-1[${PYTHON_USEDEP}]
	>=dev-python/findpython-0.7.0[${PYTHON_USEDEP}]
	dev-python/blinker[${PYTHON_USEDEP}]
	dev-python/filelock[${PYTHON_USEDEP}]
	>=dev-python/hishel-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/httpcore-1.0.6[${PYTHON_USEDEP}]
	dev-python/httpx[${PYTHON_USEDEP}]
	>=dev-python/id-1.5.0[${PYTHON_USEDEP}]
	dev-python/installer[${PYTHON_USEDEP}]
	>=dev-python/packaging-22.1[${PYTHON_USEDEP}]
	>=dev-python/pbs-installer-2025.10.07[${PYTHON_USEDEP}]
	dev-python/platformdirs[${PYTHON_USEDEP}]
	dev-python/pyproject-hooks[${PYTHON_USEDEP}]
	dev-python/python-dotenv[${PYTHON_USEDEP}]
	>=dev-python/resolvelib-1.2.0[${PYTHON_USEDEP}]
	dev-python/rich[${PYTHON_USEDEP}]
	dev-python/shellingham[${PYTHON_USEDEP}]
	dev-python/tomlkit[${PYTHON_USEDEP}]
	>=dev-python/truststore-0.10.4[${PYTHON_USEDEP}]
	>=dev-python/unearth-0.17.5[${PYTHON_USEDEP}]
	dev-python/virtualenv[${PYTHON_USEDEP}]
"
BDEPEND="
	${RDEPEND}
	test? (
		dev-python/msgpack[${PYTHON_USEDEP}]
		dev-python/uv
	)
"

EPYTEST_PLUGINS=( pytest-{httpserver,httpx,mock,rerunfailures} )
EPYTEST_RERUNS=5
EPYTEST_XDIST=1
distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# unpin deps
	sed -i -e 's:,<[0-9.a]*::' pyproject.toml || die
	# remove pkgutil namespace magic, as it doesn't work and makes
	# dev-python/pdm-backend tests test the wrong package
	rm src/pdm/__init__.py || die
}

python_test() {
	local EPYTEST_DESELECT=(
		# Internet
		'tests/models/test_candidates.py::test_expand_project_root_in_url[demo @ file:///${PROJECT_ROOT}/tests/fixtures/artifacts/demo-0.0.1.tar.gz]'
		# unhappy about extra packages being installed?
		# (also fails randomly in venv)
		tests/cli/test_build.py::test_build_with_no_isolation
		# TODO: random regression?
		tests/cli/test_python.py::test_find_python
		# TODO
		tests/test_formats.py::test_export_from_pylock_not_empty
	)

	epytest -m "not network and not integration and not path"
}
