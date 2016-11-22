# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit distutils-r1

DESCRIPTION="A configuration system for Python applications"
HOMEPAGE="https://github.com/ipython/traitlets"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="doc test"

RDEPEND="
	dev-python/decorator[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/enum34[${PYTHON_USEDEP}]' python2_7)
	dev-python/ipython_genutils[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	"
DEPEND="
	doc? (
		dev-python/ipython_genutils[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
	)
	test? (
		$(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' python2_7)
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		)
	"

python_prepare_all() {
	# Prevent un-needed download during build
	if use doc; then
		sed -e "/^    'sphinx.ext.intersphinx',/d" -i docs/source/conf.py || die
	fi

	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	py.test --cov traitlets -v traitlets || die
}

python_install_all() {
	use doc && HTML_DOCS=( docs/build/html/. )
	distutils-r1_python_install_all
}
