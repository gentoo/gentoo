# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_6 )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Raven is a client for Sentry"
HOMEPAGE="https://github.com/getsentry/raven-python"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/contextlib2[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	test? (
		dev-python/aiohttp[${PYTHON_USEDEP}]
		>=dev-python/blinker-1.1[${PYTHON_USEDEP}]
		dev-python/bottle[${PYTHON_USEDEP}]
		>=dev-python/celery-2.5[${PYTHON_USEDEP}]
		>=dev-python/exam-0.5.2[${PYTHON_USEDEP}]
		>=dev-python/flask-0.8[${PYTHON_USEDEP}]
		>=dev-python/flask-login-0.2.0[${PYTHON_USEDEP}]
		dev-python/logbook[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/paste[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
		dev-python/pytest-pythonpath[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		>=dev-python/sanic-0.7.0[${PYTHON_USEDEP}]
		dev-python/unittest2[${PYTHON_USEDEP}]
		dev-python/webob[${PYTHON_USEDEP}]
		dev-python/webpy[${PYTHON_USEDEP}]
		dev-python/webtest[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}]
		dev-python/zconfig[${PYTHON_USEDEP}]
		>=www-servers/tornado-4.1[${PYTHON_USEDEP}]
		<www-servers/tornado-5.0[${PYTHON_USEDEP}]
	)
"

src_prepare() {
	sed -i 's|--cov=raven||' setup.cfg
	default
}

distutils_enable_tests pytest
