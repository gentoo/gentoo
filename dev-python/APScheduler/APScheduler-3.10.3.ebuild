# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 pypi

DESCRIPTION="In-process task scheduler with Cron-like capabilities"
HOMEPAGE="
	https://github.com/agronholm/apscheduler/
	https://pypi.org/project/APScheduler/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/pytz[${PYTHON_USEDEP}]
	>=dev-python/six-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/tzlocal-4[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		>=dev-python/sqlalchemy-1.4[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/pytest-tornado[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

PATCHES=(
	# disable test fixtures using external servers (mongodb, redis...)
	# these fixtures are using markers in git master, so the patch
	# should be no longer necessary with next major bump
	"${FILESDIR}"/APScheduler-3.8.1-external-server-tests.patch
)

EPYTEST_DESELECT=(
	tests/test_jobstores.py::test_repr_mongodbjobstore
	tests/test_jobstores.py::test_repr_redisjobstore
	tests/test_jobstores.py::test_repr_zookeeperjobstore
	tests/test_executors.py::test_broken_pool
)

python_prepare_all() {
	# suppress setuptools warning #797751
	sed -e 's|^upload-dir|upload_dir|' -i setup.cfg || die
	sed -e '/addopts/d' -i setup.cfg || die

	distutils-r1_python_prepare_all
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p asyncio -p tornado
}
