# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..9} )
inherit distutils-r1

DESCRIPTION="Python client for Sentry"
HOMEPAGE="https://sentry.io/ https://pypi.org/project/sentry-sdk/"
SRC_URI="https://github.com/getsentry/sentry-python/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/sentry-python-${PV}"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86"

RDEPEND="
	dev-python/urllib3[${PYTHON_USEDEP}]
	dev-python/certifi[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/asttokens[${PYTHON_USEDEP}]
		dev-python/django[${PYTHON_USEDEP}]
		dev-python/executing[${PYTHON_USEDEP}]
		dev-python/eventlet[${PYTHON_USEDEP}]
		dev-python/fakeredis[${PYTHON_USEDEP}]
		dev-python/flask-login[${PYTHON_USEDEP}]
		dev-python/gevent[${PYTHON_USEDEP}]
		dev-python/jsonschema[${PYTHON_USEDEP}]
		dev-python/pyrsistent[${PYTHON_USEDEP}]
		dev-python/pytest-aiohttp[${PYTHON_USEDEP}]
		dev-python/pytest-django[${PYTHON_USEDEP}]
		dev-python/pytest-forked[${PYTHON_USEDEP}]
		dev-python/pytest-localserver[${PYTHON_USEDEP}]
		dev-python/werkzeug[${PYTHON_USEDEP}]
		dev-python/zope-event[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local EPYTEST_IGNORE=(
		# tests require Internet access
		tests/integrations/httpx/test_httpx.py
		tests/integrations/requests/test_requests.py
		tests/integrations/stdlib/test_httplib.py
		# wtf is it supposed to do?!
		tests/integrations/gcp/test_gcp.py
	)

	local EPYTEST_DESELECT=(
		# hangs
		'tests/test_transport.py::test_transport_works'
		# TODO
		'tests/test_basics.py::test_auto_enabling_integrations_catches_import_error'
		tests/test_client.py::test_databag_depth_stripping
		tests/test_client.py::test_databag_string_stripping
		tests/test_client.py::test_databag_breadth_stripping
		# incompatible version?
		tests/integrations/falcon/test_falcon.py
		tests/integrations/sqlalchemy/test_sqlalchemy.py::test_too_large_event_truncated
		# test_circular_references: apparently fragile
		'tests/integrations/threading/test_threading.py::test_circular_references'
		# test for new feature, fails with IndexError
		tests/integrations/wsgi/test_wsgi.py::test_session_mode_defaults_to_request_mode_in_wsgi_handler
	)

	# Prevent tests/integrations/modules/test_modules.py:test_basic failure
	# Needs to detect sentry-sdk in the installed modules
	distutils_install_for_testing

	epytest
}
