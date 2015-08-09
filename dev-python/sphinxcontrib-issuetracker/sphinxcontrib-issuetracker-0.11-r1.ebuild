# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="Extension to sphinx to create links to issue trackers"
HOMEPAGE="http://sphinxcontrib-issuetracker.readthedocs.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm x86"

IUSE="doc test"

RDEPEND=">=dev-python/requests-0.13[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.1[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)"

python_prepare_all() {
	# test requires network access (bug #425694)
	rm tests/test_builtin_trackers.py || die

	# Tests from tests/test_stylesheet.py require dev-python/PyQt4[X,webkit]
	# and virtualx.eclass.
	rm tests/test_stylesheet.py || die

	# Avoid redundant objects.inv from downloading, sed more lightwieght
	if use doc; then
		sed -e "s:^intersphinx_mapping:#intersphinx_mapping:" \
			-e "s:^                       'sphinx':#:" \
			-i doc/conf.py || die
	fi
}

python_compile_all() {
	use doc && emake -C doc html
}

python_test() {
	py.test || die
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/_build/html )
	distutils-r1_python_install_all
}
