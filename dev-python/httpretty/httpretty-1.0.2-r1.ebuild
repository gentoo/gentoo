# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1

DESCRIPTION="HTTP client mock for Python"
HOMEPAGE="https://github.com/gabrielfalcao/httpretty"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="amd64 ~arm64 x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/urllib3[${PYTHON_USEDEP}]"
# redis skipped as it requires a redis server running
DEPEND="
	test? (
		dev-python/eventlet[${PYTHON_USEDEP}]
		dev-python/freezegun[${PYTHON_USEDEP}]
		dev-python/httplib2[${PYTHON_USEDEP}]
		>=dev-python/nose-1.2[${PYTHON_USEDEP}]
		dev-python/pyopenssl[${PYTHON_USEDEP}]
		>=dev-python/requests-1.1[${PYTHON_USEDEP}]
		dev-python/sure[${PYTHON_USEDEP}]
		>=www-servers/tornado-2.2[${PYTHON_USEDEP}]
)"

python_prepare_all() {
	# remove useless deps
	sed -i -e '/randomly/d' -e '/rednose/d' setup.cfg || die
	# tests requiring network access
	rm tests/functional/test_passthrough.py || die
	# requires running redis server
	# it is skipped correctly but it causes unnecessary dep on redis-py
	rm tests/functional/bugfixes/test_redis.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	nosetests -v tests || die "Tests fail with ${EPYTHON}"
}
