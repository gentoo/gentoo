# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="A terminal-based console frontend for Jupyter kernels"
HOMEPAGE="https://jupyter.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/ipython[${PYTHON_USEDEP}]
	dev-python/ipykernel[${PYTHON_USEDEP}]
	dev-python/jupyter_client[${PYTHON_USEDEP}]
	>=dev-python/prompt_toolkit-1.0.0[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		$(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' 'python2*')
		dev-python/pexpect[${PYTHON_USEDEP}]
		>=dev-python/nose-0.10.1[${PYTHON_USEDEP}]
	)
	"

python_prepare_all() {
	# Prevent un-needed download during build
	if use doc; then
		sed -e "/^    'sphinx.ext.intersphinx',/d" -i docs/conf.py || die
	fi

	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		emake -C docs html
		HTML_DOCS=( docs/_build/html/. )
	fi
}

python_test() {
	nosetests --with-coverage --cover-package=jupyter_console jupyter_console || die
}
