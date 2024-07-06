# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..12} )

inherit distutils-r1

MY_P=sentry-python-${PV}
DESCRIPTION="Python client for Sentry"
HOMEPAGE="
	https://sentry.io/
	https://github.com/getsentry/sentry-python/
	https://pypi.org/project/sentry-sdk/
"
SRC_URI="
	https://github.com/getsentry/sentry-python/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ppc ~ppc64 ~riscv ~sparc x86"

RDEPEND="
	dev-python/urllib3[${PYTHON_USEDEP}]
	dev-python/certifi[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/asttokens[${PYTHON_USEDEP}]
		dev-python/executing[${PYTHON_USEDEP}]
		dev-python/fakeredis[${PYTHON_USEDEP}]
		dev-python/flask-login[${PYTHON_USEDEP}]
		dev-python/jsonschema[${PYTHON_USEDEP}]
		dev-python/pyrsistent[${PYTHON_USEDEP}]
		<dev-python/pytest-8[${PYTHON_USEDEP}]
		dev-python/pytest-aiohttp[${PYTHON_USEDEP}]
		dev-python/pytest-forked[${PYTHON_USEDEP}]
		dev-python/pytest-localserver[${PYTHON_USEDEP}]
		dev-python/python-socks[${PYTHON_USEDEP}]
		dev-python/responses[${PYTHON_USEDEP}]
		dev-python/werkzeug[${PYTHON_USEDEP}]
		dev-python/zope-event[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}/sentry-sdk-1.21.0-ignore-warnings.patch"
)

python_test() {
	local EPYTEST_IGNORE=(
		# tests require Internet access
		tests/integrations/httpx/test_httpx.py
		tests/integrations/requests/test_requests.py
		tests/integrations/django/test_basic.py
		tests/integrations/socket/test_socket.py
		# wtf is it supposed to do?!
		tests/integrations/gcp/test_gcp.py
		# TODO
		tests/integrations/bottle
		# TODO: most of them hang
		tests/integrations/starlette
		# TODO
		tests/integrations/tornado
		# requires mockupdb
		tests/integrations/pymongo
		# requires AWS access
		tests/integrations/aws_lambda
		# requires quart_auth
		tests/integrations/quart
		# TODO: require opentelemetry (with py3.10)
		tests/integrations/opentelemetry
		# broken (incompatible rq version?)
		tests/integrations/rq
	)

	local EPYTEST_DESELECT=(
		# hangs
		tests/integrations/threading/test_threading.py::test_propagates_threadpool_hub
		# broken teardown?
		tests/test_client.py::test_uwsgi_warnings
		# too many dependencies installed, sigh
		tests/test_new_scopes_compat_event.py
		# Internet
		tests/integrations/stdlib/test_httplib.py::test_outgoing_trace_headers
		tests/integrations/stdlib/test_httplib.py::test_outgoing_trace_headers_head_sdk
		# TODO
		tests/integrations/aiohttp/test_aiohttp.py::test_basic
		tests/integrations/django
		tests/integrations/sqlalchemy/test_sqlalchemy.py::test_orm_queries
		tests/integrations/sqlalchemy/test_sqlalchemy.py::test_query_source
		tests/integrations/sqlalchemy/test_sqlalchemy.py::test_transactions
		tests/integrations/stdlib/test_subprocess.py::test_subprocess_basic
		tests/integrations/threading/test_threading.py
		tests/integrations/wsgi/test_wsgi.py
		tests/test_basics.py::test_auto_enabling_integrations_catches_import_error
		tests/test_client.py::test_databag_breadth_stripping
		tests/test_client.py::test_databag_depth_stripping
		tests/test_client.py::test_databag_string_stripping
		tests/test_utils.py::test_default_release
		tests/tracing/test_sampling.py::test_records_lost_event_only_if_traces_sample_rate_enabled
		tests/tracing/test_sampling.py::test_records_lost_event_only_if_traces_sampler_enabled
		tests/utils/test_contextvars.py::test_leaks
		# pointless, fragile to packages being installed in parallel
		tests/test_utils.py::test_installed_modules
		# TODO
		tests/profiler/test_continuous_profiler.py::test_continuous_profiler_auto_start_and_manual_stop
		tests/profiler/test_continuous_profiler.py::test_continuous_profiler_manual_start_and_stop
		tests/profiler/test_transaction_profiler.py::test_minimum_unique_samples_required
		tests/profiler/test_transaction_profiler.py::test_profile_captured
		tests/profiler/test_transaction_profiler.py::test_profiles_sample_rate
		tests/profiler/test_transaction_profiler.py::test_profiles_sampler
	)

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p asyncio -p aiohttp -p pytest_forked
}
