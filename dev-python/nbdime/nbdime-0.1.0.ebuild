# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python3_{4,5} )

inherit distutils-r1

DESCRIPTION="Diff and merge of Jupyter Notebooks"
HOMEPAGE="http://jupyter.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="~amd64"

LICENSE="BSD"
SLOT="0"
IUSE="test webtools"

RDEPEND="
	dev-python/nbformat[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/colorama[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	www-servers/tornado[${PYTHON_USEDEP}]
	webtools? ( net-libs/nodejs[npm] )
	"
DEPEND="${RDEPEND}
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
		dev-python/jsonschema[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
	)
	"
# The package recommonmark is required to build the docs, not in portage yet.
# Furthermore, backports.shutil_which is required for python2_7.

python_configure_all() {
	if ! use webtools; then
		mydistutilsargs=( --skip-npm )
	fi
}

python_test() {
	# user.email and user.name are not configured in the sandbox.
	git config --global user.email "you@example.com" || die
	git config --global user.name "Your Name" || die

	distutils_install_for_testing

	py.test -l || die
}
