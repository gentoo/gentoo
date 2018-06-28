# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="Provides access to the system keyring service"
HOMEPAGE="https://github.com/jaraco/keyring"
SRC_URI="mirror://pypi/k/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="PSF-2"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/setuptools_scm-1.15.0[${PYTHON_USEDEP}]
	<dev-python/secretstorage-3.0.0[${PYTHON_USEDEP}]
	dev-python/entrypoints[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-runner[${PYTHON_USEDEP}]
		>=dev-python/pytest-2.8[${PYTHON_USEDEP}]
		dev-python/pytest-flake8[${PYTHON_USEDEP}]
		dev-python/collective-checkdocs[${PYTHON_USEDEP}]
	)"
RDEPEND=""

src_unpack() {
	unpack $A
	# This is an interactive test.
	rm -f "${S}"/keyring/tests/backends/test_kwallet.py
}

python_test() {
	py.test -v -v || die "testsuite failed under ${EPYTHON}"
}
