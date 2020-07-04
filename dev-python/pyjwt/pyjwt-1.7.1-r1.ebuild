# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{6..9} pypy3 )

inherit distutils-r1 eutils

MY_PN="PyJWT"
DESCRIPTION="JSON Web Token implementation in Python"
HOMEPAGE="https://github.com/progrium/pyjwt https://pypi.org/project/PyJWT/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"
S="${WORKDIR}"/${MY_PN}-${PV}

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86 ~amd64-linux ~x86-linux"

RDEPEND=""
DEPEND="
	test? (
		>=dev-python/cryptography-1.4.0[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

python_prepare_all() {
	find . -name '__pycache__' -prune -exec rm -rf {} + || die
	find . -name '*.pyc' -delete || die

	# enables coverage, we don't need that
	rm setup.cfg || die
	# kill tests using pycrypto that break with pycryptodome
	sed -i -e '/has_pycrypto/s:True:False:' \
		tests/contrib/test_algorithms.py || die

	local PATCHES=(
		"${FILESDIR}"/pyjwt-1.7.1-ecdsa-fix.patch
	)

	distutils-r1_python_prepare_all
}

python_test() {
	pytest -vv || die "Tests fail with ${EPYTHON}"
}

pkg_postinst() {
	elog "Available optional features:"
	optfeature "cryptography" dev-python/cryptography
	optfeature "flake8" dev-python/flake8{,-import-order}

	ewarn "flake8 feature requires 'pep8-naming' which is not packaged yet"
}
