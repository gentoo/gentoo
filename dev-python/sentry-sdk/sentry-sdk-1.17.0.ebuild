# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

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
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"

RDEPEND="
	dev-python/urllib3[${PYTHON_USEDEP}]
	dev-python/certifi[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/asttokens[${PYTHON_USEDEP}]
		dev-python/django[${PYTHON_USEDEP}]
		dev-python/executing[${PYTHON_USEDEP}]
		dev-python/fakeredis[${PYTHON_USEDEP}]
		dev-python/flask-login[${PYTHON_USEDEP}]
		dev-python/jsonschema[${PYTHON_USEDEP}]
		dev-python/pyrsistent[${PYTHON_USEDEP}]
		dev-python/pytest-aiohttp[${PYTHON_USEDEP}]
		dev-python/pytest-django[${PYTHON_USEDEP}]
		dev-python/pytest-forked[${PYTHON_USEDEP}]
		dev-python/pytest-localserver[${PYTHON_USEDEP}]
		dev-python/responses[${PYTHON_USEDEP}]
		dev-python/werkzeug[${PYTHON_USEDEP}]
		dev-python/zope-event[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_IGNORE=(
	# tests require Internet access
	tests/integrations/httpx/test_httpx.py
	tests/integrations/requests/test_requests.py
	tests/integrations/stdlib/test_httplib.py
	tests/integrations/flask/test_flask.py
	tests/integrations/django/test_basic.py
	# wtf is it supposed to do?!
	tests/integrations/gcp/test_gcp.py
	# broken by rq-1.10.1 (optional dep)
	tests/integrations/rq/test_rq.py
	# fastapi is not packaged
	tests/integrations/asgi/test_fastapi.py
	# TODO
	tests/integrations/bottle
	# TODO: causes breakage in other tests
	tests/integrations/starlette
	# TODO
	tests/integrations/tornado
	# requires mockupdb
	tests/integrations/pymongo
)

EPYTEST_DESELECT=(
	# hangs
	'tests/test_transport.py::test_transport_works'
	# TODO
	'tests/test_basics.py::test_auto_enabling_integrations_catches_import_error'
	tests/test_client.py::test_databag_depth_stripping
	tests/test_client.py::test_databag_string_stripping
	tests/test_client.py::test_databag_breadth_stripping
	tests/integrations/asgi/test_asgi.py::test_auto_session_tracking_with_aggregates
	tests/integrations/asgi/test_asgi.py::test_websocket
	tests/integrations/aiohttp/test_aiohttp.py::test_transaction_style
	tests/integrations/aiohttp/test_aiohttp.py::test_traces_sampler_gets_request_object_in_sampling_context
	# incompatible version?
	tests/integrations/falcon/test_falcon.py
	tests/integrations/sqlalchemy/test_sqlalchemy.py::test_too_large_event_truncated
	# test_circular_references: apparently fragile
	'tests/integrations/threading/test_threading.py::test_circular_references'
	# test for new feature, fails with IndexError
	tests/integrations/wsgi/test_wsgi.py::test_session_mode_defaults_to_request_mode_in_wsgi_handler
	# TODO
	tests/integrations/wsgi/test_wsgi.py::test_auto_session_tracking_with_aggregates
	tests/integrations/wsgi/test_wsgi.py::test_profile_sent_when_profiling_enabled
	tests/test_profiler.py::test_sample_buffer
	tests/test_profiler.py::test_thread_scheduler_takes_first_samples
	tests/test_profiler.py::test_thread_scheduler_takes_more_samples
	tests/test_profiler.py::test_thread_scheduler_single_background_thread
	# broken with py3.11, *shrug*
	tests/test_profiler.py::test_extract_stack_with_max_depth
	# TODO
	tests/integrations/sqlalchemy/test_sqlalchemy.py::test_long_sql_query_preserved
)
