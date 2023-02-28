# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1 pypi systemd

DESCRIPTION="Synchronize calendars and contacts"
HOMEPAGE="
	https://github.com/pimutils/vdirsyncer/
	https://pypi.org/project/vdirsyncer/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	<dev-python/click-9[${PYTHON_USEDEP}]
	>=dev-python/click-5.0[${PYTHON_USEDEP}]
	<dev-python/click-log-0.5.0[${PYTHON_USEDEP}]
	>=dev-python/click-log-0.3.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.20.0[${PYTHON_USEDEP}]
	>=dev-python/requests-toolbelt-0.4.0[${PYTHON_USEDEP}]
	>=dev-python/atomicwrites-0.1.7[${PYTHON_USEDEP}]
	<dev-python/aiohttp-4[${PYTHON_USEDEP}]
	>=dev-python/aiohttp-3.8.0[${PYTHON_USEDEP}]
	<dev-python/aiostream-0.5.0[${PYTHON_USEDEP}]
	>=dev-python/aiostream-0.4.3[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/pytest-httpserver[${PYTHON_USEDEP}]
		dev-python/trustme[${PYTHON_USEDEP}]
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
		dev-python/aioresponses[${PYTHON_USEDEP}]
	)
"

DOCS=( AUTHORS.rst CHANGELOG.rst CONTRIBUTING.rst README.rst config.example )

distutils_enable_tests pytest

python_test() {
	# skip tests needing servers running
	local -x DAV_SERVER=skip
	local -x REMOTESTORAGE_SERVER=skip
	# pytest dies hard if the envvars do not have any value...
	local -x CI=false
	local -x DETERMINISTIC_TESTS=false

	local EPYTEST_DESELECT=(
		# Internet
		tests/system/utils/test_main.py::test_request_ssl
	)

	epytest -o addopts=
}

src_install() {
	distutils-r1_src_install

	systemd_douserunit contrib/vdirsyncer.{service,timer}
}
