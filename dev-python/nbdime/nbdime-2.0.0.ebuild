# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1

DESCRIPTION="Diff and merge of Jupyter Notebooks"
HOMEPAGE="https://jupyter.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="webtools"

RDEPEND="
	dev-python/colorama[${PYTHON_USEDEP}]
	dev-python/GitPython[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/nbformat[${PYTHON_USEDEP}]
	dev-python/notebook[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	www-servers/tornado[${PYTHON_USEDEP}]
	webtools? ( net-libs/nodejs[npm] )"
BDEPEND="
	test? (
		dev-python/jsonschema[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
		dev-python/tabulate[${PYTHON_USEDEP}]
	)"

distutils_enable_sphinx docs/source \
	dev-python/recommonmark dev-python/sphinx_rtd_theme
distutils_enable_tests pytest

PATCHES=( "${FILESDIR}"/${PN}-2.0.0-remove-bdist_egg-hack.patch )

python_configure_all() {
	use webtools || mydistutilsargs=( --skip-npm )
}

python_test() {
	# user.email and user.name are not configured in the sandbox
	git config --global user.email "you@example.com" || die
	git config --global user.name "Your Name" || die

	distutils_install_for_testing
	pytest -vv || die "Tests fail with ${EPYTHON}"
}
