# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_PN=APScheduler
PYPI_VERIFY_REPO=https://github.com/agronholm/apscheduler
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1 pypi

DESCRIPTION="In-process task scheduler with Cron-like capabilities"
HOMEPAGE="
	https://github.com/agronholm/apscheduler/
	https://pypi.org/project/APScheduler/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-python/tzlocal-4[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	test? (
		dev-python/pytz[${PYTHON_USEDEP}]
		>=dev-python/sqlalchemy-1.4[${PYTHON_USEDEP}]
		dev-python/tornado[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( anyio pytest-timeout )
distutils_enable_tests pytest

PATCHES=(
	# disable test fixtures using external servers (mongodb, redis...)
	"${FILESDIR}"/apscheduler-3.11.3-external-server-tests.patch
)

EPYTEST_RERUNS=10
EPYTEST_DESELECT=(
	# require etcd3
	tests/test_jobstores.py::test_etcd_client_ref
	tests/test_jobstores.py::test_etcd_null_path
)
