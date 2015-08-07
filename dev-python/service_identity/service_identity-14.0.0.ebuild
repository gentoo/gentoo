# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/service_identity/service_identity-14.0.0.ebuild,v 1.9 2015/08/07 16:24:08 klausman Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="Service identity verification for pyOpenSSL"
HOMEPAGE="https://github.com/pyca/service_identity"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE=" MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 m68k ppc ppc64 s390 sh x86"
IUSE="doc test"

RDEPEND="dev-python/pyasn1[${PYTHON_USEDEP}]
		dev-python/pyasn1-modules[${PYTHON_USEDEP}]
		>=dev-python/pyopenssl-0.12[${PYTHON_USEDEP}]
		>=dev-python/characteristic-14.0.0[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}] )"

python_prepare_all() {
	# Prevent un-needed download during build
	sed -e "/^    'sphinx.ext.intersphinx',/d" -i docs/conf.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	# testsuite not supported by py3.2 which is about to become deprecated
	if ! [[ "${EPYTHON}" == python3.2 ]]; then
		py.test --cov service_identity --cov-report term-missing || die "tests failed under ${EPYTHON}"
	fi
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
