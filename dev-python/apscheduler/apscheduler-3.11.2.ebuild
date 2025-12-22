# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_PN=APScheduler
PYPI_VERIFY_REPO=https://github.com/agronholm/apscheduler
PYTHON_COMPAT=( python3_{11..14} )

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
	"${FILESDIR}"/apscheduler-3.11.0-external-server-tests.patch
)
