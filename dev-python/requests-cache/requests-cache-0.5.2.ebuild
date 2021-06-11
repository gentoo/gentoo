# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1

HOMEPAGE="https://pypi.org/project/requests-cache/"
DESCRIPTION="Persistent cache for requests library"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="dev-python/requests[${PYTHON_USEDEP}]"

distutils_enable_sphinx docs
distutils_enable_tests pytest

src_prepare() {
	# Ships with incorrect mock import
	sed -e 's/import mock/import unittest.mock as mock/' -i tests/test_cache.py || die
	default
}

python_test() {
	local skipped_tests=(
		# Slew of tests that violate network-sandbox
		tests/test_cache.py::CacheTestCase::test_attr_from_cache_in_hook
		tests/test_cache.py::CacheTestCase::test_cache_unpickle_errors
		tests/test_cache.py::CacheTestCase::test_close_response
		tests/test_cache.py::CacheTestCase::test_content_and_cookies
		tests/test_cache.py::CacheTestCase::test_delete_urls
		tests/test_cache.py::CacheTestCase::test_disabled
		tests/test_cache.py::CacheTestCase::test_enabled
		tests/test_cache.py::CacheTestCase::test_expire_cache
		tests/test_cache.py::CacheTestCase::test_from_cache_attribute
		tests/test_cache.py::CacheTestCase::test_get_parameters_normalization
		tests/test_cache.py::CacheTestCase::test_get_params_as_argument
		tests/test_cache.py::CacheTestCase::test_gzip_response
		tests/test_cache.py::CacheTestCase::test_headers_in_get_query
		tests/test_cache.py::CacheTestCase::test_hooks
		tests/test_cache.py::CacheTestCase::test_https_support
		tests/test_cache.py::CacheTestCase::test_ignore_parameters_get
		tests/test_cache.py::CacheTestCase::test_ignore_parameters_post
		tests/test_cache.py::CacheTestCase::test_ignore_parameters_post_json
		tests/test_cache.py::CacheTestCase::test_ignore_parameters_post_raw
		tests/test_cache.py::CacheTestCase::test_post
		tests/test_cache.py::CacheTestCase::test_post_data
		tests/test_cache.py::CacheTestCase::test_post_parameters_normalization
		tests/test_cache.py::CacheTestCase::test_post_params
		tests/test_cache.py::CacheTestCase::test_remove_expired_entries
		tests/test_cache.py::CacheTestCase::test_response_history
		tests/test_cache.py::CacheTestCase::test_response_history_simple
		tests/test_cache.py::CacheTestCase::test_return_old_data_on_error
		tests/test_cache.py::CacheTestCase::test_stream_requests_support
		tests/test_monkey_patch.py::MonkeyPatchTestCase::test_requests_from_cache

		# This throws many errors with network-sandbox, but doesn't fail the
		# build
		tests/test_thread_safety::test_thread_safety
	)

	# Redis tests need a redis server running
	pytest -vv --ignore tests/test_redisdict.py ${skipped_tests[@]/#/--deselect } || die "Tests fail with ${EPYTHON}"
}
