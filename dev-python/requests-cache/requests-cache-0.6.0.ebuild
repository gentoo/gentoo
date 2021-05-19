# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1

HOMEPAGE="https://pypi.org/project/requests-cache/"
DESCRIPTION="Persistent cache for requests library"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/itsdangerous[${PYTHON_USEDEP}]
	>=dev-python/requests-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/url-normalize-1.4[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		$(python_gen_any_dep '
			dev-python/httpbin[${PYTHON_USEDEP}]
			www-servers/gunicorn[${PYTHON_USEDEP}]
		')
	)"

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/${P}-test-install.patch
)

python_check_deps() {
	use test || return 0

	has_version -b "dev-python/httpbin[${PYTHON_USEDEP}]" &&
		has_version -b "www-servers/gunicorn[${PYTHON_USEDEP}]"
}

src_test() {
	local hostport="127.0.0.1:23125"
	python_setup
	einfo "Starting httpbin on ${hostport}"
	gunicorn -b "${hostport}" -D -p gunicorn.pid httpbin:app || die

	local -x HTTPBIN_URL="http://${hostport}/"
	distutils-r1_src_test
	kill $(<gunicorn.pid) || die
}

python_test() {
	local skipped_tests=(
		# These require extra servers running
		tests/integration/test_dynamodb.py
		tests/integration/test_gridfs.py
		tests/integration/test_mongodb.py
		tests/integration/test_redis.py

		# TODO
		'tests/integration/test_cache.py::test_all_response_formats[json]'
	)

	epytest ${skipped_tests[@]/#/--deselect }
}
