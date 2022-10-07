# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="In-process task scheduler with Cron-like capabilities"
HOMEPAGE="https://github.com/agronholm/apscheduler"
SRC_URI="mirror://pypi/A/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/pytz[${PYTHON_USEDEP}]
	>=dev-python/six-1.4.0[${PYTHON_USEDEP}]
	>=dev-python/tzlocal-4[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		dev-python/sqlalchemy[${PYTHON_USEDEP}]
		dev-python/tornado[${PYTHON_USEDEP}]
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
)

python_prepare_all() {
	# suppress setuptools warning #797751
	sed -e 's|^upload-dir|upload_dir|' -i setup.cfg || die
	sed -e '/addopts/d' -i setup.cfg || die

	distutils-r1_python_prepare_all
}
