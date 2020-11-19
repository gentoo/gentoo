# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1

DESCRIPTION="Python client for Sentry"
HOMEPAGE="https://getsentry.com https://pypi.org/project/sentry-sdk/"
SRC_URI="https://github.com/getsentry/sentry-python/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/sentry-python-${PV}"

LICENSE="PSF-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="
	dev-python/urllib3[${PYTHON_USEDEP}]
	dev-python/certifi[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/asttokens[${PYTHON_USEDEP}]
		dev-python/django[${PYTHON_USEDEP}]
		<dev-python/dnspython-2[${PYTHON_USEDEP}]
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
		$(python_gen_cond_dep '
			dev-python/aiocontextvars[${PYTHON_USEDEP}]
			dev-python/contextvars[${PYTHON_USEDEP}]
		' python3_6)
	)
"

distutils_enable_tests pytest

python_test() {
	local deselect=(
		# tests require Internet access
		--deselect tests/integrations/stdlib/test_httplib.py
		--deselect tests/integrations/requests/test_requests.py
		# wtf is it supposed to do?!
		--deselect tests/integrations/gcp/test_gcp.py
		# fails on py3.6, hangs on py3.7+
		--deselect
		'tests/test_transport.py::test_transport_works[eventlet'
		# TODO
		--deselect
		'tests/test_basics.py::test_auto_enabling_integrations_catches_import_error'
		--deselect
		tests/test_client.py::test_databag_depth_stripping
		--deselect
		tests/test_client.py::test_databag_string_stripping
		--deselect
		tests/test_client.py::test_databag_breadth_stripping
		# test_filename: apparently unhappy about pytest being called pytest
		--deselect 'tests/utils/test_general.py::test_filename'
		# test_circular_references: apparently fragile
		--deselect
		'tests/integrations/threading/test_threading.py::test_circular_references'
	)
	[[ ${EPYTHON} == python3.6 ]] && deselect+=(
		# broken with contextvars on py3.6
		--deselect
		'tests/utils/test_contextvars.py::test_leaks[greenlet]'
		--deselect
		'tests/test_transport.py::test_transport_works[greenlet'
	)

	# Prevent tests/integrations/modules/test_modules.py:test_basic failure
	# Needs to detect sentry-sdk in the installed modules
	distutils_install_for_testing

	pytest -vv "${deselect[@]}" || die "Tests failed with ${EPYTHON}"
}
