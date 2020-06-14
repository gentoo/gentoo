# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=(python3_{6..8})

inherit distutils-r1

DESCRIPTION="Python client for Sentry"
HOMEPAGE="https://getsentry.com https://pypi.org/project/sentry-sdk/ https://github.com/getsentry/sentry-python"
SRC_URI="https://github.com/getsentry/sentry-python/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

S="${WORKDIR}/sentry-python-${PV}"

RDEPEND="
	dev-python/urllib3
	dev-python/certifi
"

BDEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
	 dev-python/pytest-asyncio[${PYTHON_USEDEP}]
	 dev-python/pytest-forked[${PYTHON_USEDEP}]
	 dev-python/pytest-localserver[${PYTHON_USEDEP}]
	 dev-python/eventlet[${PYTHON_USEDEP}]
	 dev-python/gevent[${PYTHON_USEDEP}]
	 dev-python/werkzeug[${PYTHON_USEDEP}]
	)
"

PATCHES=( "${FILESDIR}/${PN}-0.14.4-disable-auto-enabling-intregrations-tests.patch" )

distutils_enable_tests pytest

src_prepare() {
	# reason for removal:
	# test_requests.py - requires internet access
	# test_httplib.py - requires internet access
	# test_transport.py - failing with ebuild somehow, running tests directly via pytest works
	# django integration tests - failing, also upstream failing when called directly - via tox these are working
	if use test; then
		rm --recursive \
			"${S}"/tests/integrations/requests/test_requests.py \
			"${S}"/tests/integrations/stdlib/test_httplib.py \
			"${S}"/tests/test_transport.py \
			"${S}"/tests/integrations/django
	fi

  sed --in-place --expression='/sentry_sdk.integrations.django.DjangoIntegration/d' sentry_sdk/integrations/__init__.py

  default
}

python_test() {
  distutils_install_for_testing
	pytest -vv tests || die "Tests fail with ${EPYTHON}"
}
