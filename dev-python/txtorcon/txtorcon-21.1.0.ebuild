# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8,9,10} )

inherit distutils-r1

DESCRIPTION="Twisted-based Tor controller client, with state-tracking and config abstractions"
HOMEPAGE="https://github.com/meejah/txtorcon https://pypi.org/project/txtorcon/ https://txtorcon.readthedocs.org"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/automat[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/incremental[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/twisted-16.0.0[${PYTHON_USEDEP},crypt]
	>=dev-python/zope-interface-3.6.1[${PYTHON_USEDEP}]
	doc? (
		dev-python/automat[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/repoze-sphinx-autointerface[${PYTHON_USEDEP}]
		>=dev-python/zope-interface-3.6.1[${PYTHON_USEDEP}]
	)
"

DEPEND="
	${RDEPEND}
	test? ( dev-python/mock[${PYTHON_USEDEP}] )
"

python_prepare_all() {
	sed -e "s/^ipaddress.*//" -i requirements.txt || die

	distutils-r1_python_prepare_all
}
python_test() {
	pushd "${TEST_DIR}" > /dev/null || die
	/usr/bin/trial txtorcon || die "Tests failed with ${EPYTHON}"
	popd > /dev/null || die
}

python_compile_all() {
	use doc && emake -C "${S}/docs" html
}

python_install_all() {
	use doc && dodoc -r "${S}/docs/_build/html/"*
	use examples && dodoc -r "${S}/examples/"
	distutils-r1_python_install_all
}
