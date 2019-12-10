# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit bash-completion-r1 distutils-r1

DESCRIPTION="novaclient wrapper for multiple nova environments"
HOMEPAGE="https://github.com/rackerhacker/supernova"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc examples test"
RESTRICT="!test? ( test )"

CDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="
	${CDEPEND}
	doc? ( >=dev-python/mkdocs-0.14.0[${PYTHON_USEDEP}] )
	test? ( <dev-python/pytest-4.0.0[${PYTHON_USEDEP}] )
"
RDEPEND="
	${CDEPEND}
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/configobj[${PYTHON_USEDEP}]
	>=dev-python/keyring-0.9.2[${PYTHON_USEDEP}]
	dev-python/python-novaclient[${PYTHON_USEDEP}]
	dev-python/rackspace-novaclient[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"

python_compile_all() {
	if use doc; then
		mkdocs build || die "docs failed to build"
	fi
}

python_test() {
	py.test || die "tests failed under ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( site/. )
	use examples && local EXAMPLES=( example_configs/. )

	distutils-r1_python_install_all

	newbashcomp contrib/${PN}-completion.bash ${PN}
}
