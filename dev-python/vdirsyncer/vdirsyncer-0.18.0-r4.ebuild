# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1 systemd

DESCRIPTION="Synchronize calendars and contacts"
HOMEPAGE="
	https://github.com/pimutils/vdirsyncer/
	https://pypi.org/project/vdirsyncer/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"

RDEPEND="
	dev-python/click[${PYTHON_USEDEP}]
	>=dev-python/click-log-0.3.0[${PYTHON_USEDEP}]
	>=dev-python/click-threading-0.5[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/requests-toolbelt[${PYTHON_USEDEP}]
	dev-python/atomicwrites[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/pytest-localserver[${PYTHON_USEDEP}]
		dev-python/pytest-subtesthack[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-0.18.0-no-cov.patch"
)

DOCS=( AUTHORS.rst CHANGELOG.rst CONTRIBUTING.rst README.rst config.example )

distutils_enable_tests pytest

src_prepare() {
	# unpin click-log
	# https://github.com/pimutils/vdirsyncer/commit/ea640001d0ad6e56369102e02b949c865c48726f
	sed -i -e '/click-log/s:, <0.4.0::' setup.py || die
	distutils-r1_src_prepare
}

python_test() {
	# skip tests needing servers running
	local -x DAV_SERVER=skip
	local -x REMOTESTORAGE_SERVER=skip
	# pytest dies hard if the envvars do not have any value...
	local -x CI=false
	local -x DETERMINISTIC_TESTS=false

	local EPYTEST_DESELECT=(
		# test CA is too weak for modern python
		tests/system/utils/test_main.py::test_request_ssl
		tests/system/utils/test_main.py::test_request_ssl_fingerprints
	)

	epytest
}

src_install() {
	distutils-r1_src_install

	systemd_douserunit contrib/vdirsyncer.{service,timer}
}
