# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=(python3_{6..8})

inherit distutils-r1

DESCRIPTION="Python client for Sentry"
HOMEPAGE="https://getsentry.com https://pypi.org/project/sentry-sdk/ https://github.com/getsentry/sentry-python"
SRC_URI="https://github.com/getsentry/sentry-python/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/sentry-python-${PV}"

RDEPEND="
	dev-python/urllib3[${PYTHON_USEDEP}]
	dev-python/certifi[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/aiocontextvars[${PYTHON_USEDEP}]' python3_6	)
"

BDEPEND="
	test? (
		dev-python/pytest-aiohttp[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/pytest-forked[${PYTHON_USEDEP}]
		dev-python/pytest-localserver[${PYTHON_USEDEP}]
		dev-python/eventlet[${PYTHON_USEDEP}]
		dev-python/flask-login[${PYTHON_USEDEP}]
		dev-python/gevent[${PYTHON_USEDEP}]
		dev-python/werkzeug[${PYTHON_USEDEP}]
		dev-python/zope-event[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_prepare() {
	# reason for removal:
	# test_requests.py - requires internet access
	# test_httplib.py - requires internet access
	# test_transport.py - failing somehow, running tests directly via pytest works
	# django integration tests - failing, also upstream failing when called directly
	if use test; then
		rm --recursive \
			"${S}"/tests/integrations/requests/test_requests.py \
			"${S}"/tests/integrations/stdlib/test_httplib.py \
			"${S}"/tests/test_transport.py \
			"${S}"/tests/integrations/django || die

		# disable-auto-enabling-intregrations-tests
		sed -i -e 's:test_auto_enabling_integrations_catches_import_error:_&:' \
			tests/test_basics.py || die

		# fails at 'assert x("pytest", pytest.__file__) == "pytest.py"'
		sed -i -e 's:test_filename:_&:' tests/utils/test_general.py
	fi

	sed -i -e '/sentry_sdk.integrations.django.DjangoIntegration/d' \
		sentry_sdk/integrations/__init__.py || die

	distutils-r1_src_prepare
}

python_test() {
	distutils_install_for_testing
	pytest -vv tests || die "Tests fail with ${EPYTHON}"
}
