# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="Jupyter Interactive Notebook"
HOMEPAGE="http://jupyter.org"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"
RDEPEND="
	>=dev-libs/mathjax-2.4
	dev-python/jinja[${PYTHON_USEDEP}]
	>=dev-python/terminado-0.3.3[${PYTHON_USEDEP}]
	>=www-servers/tornado-4.0[${PYTHON_USEDEP}]
	dev-python/ipython_genutils[${PYTHON_USEDEP}]
	>=dev-python/traitlets-4.2.1[${PYTHON_USEDEP}]
	dev-python/jupyter_core[${PYTHON_USEDEP}]
	dev-python/jupyter_client[${PYTHON_USEDEP}]
	dev-python/nbformat[${PYTHON_USEDEP}]
	>=dev-python/nbconvert-4.2.0[${PYTHON_USEDEP}]
	dev-python/ipykernel[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		$(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' 'python2*')
		>=dev-python/nose-0.10.1[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
	)
	doc? (
		app-text/pandoc
		>=dev-python/ipython-4.0.0[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.1[${PYTHON_USEDEP}]
	)
	"

PATCHES=( "${FILESDIR}/${PN}"-4.2.0-setupbase.py.patch )

python_prepare_all() {
	sed \
		-e "/import setup/s:$:\nimport setuptools:g" \
		-i setup.py || die

	# disable bundled mathjax
	sed -i 's/^.*MathJax.*$//' bower.json || die

	# Prevent un-needed download during build
	if use doc; then
		sed \
			-e "/^    'sphinx.ext.intersphinx',/d" \
			-i docs/source/conf.py || die
	fi

	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		emake -C docs html
		HTML_DOCS=( docs/build/html/. )
	fi
}

python_test() {
	nosetests \
		--verbosity=3 \
		notebook || die
}

python_install() {
	distutils-r1_python_install

	ln -sf \
		"${EPREFIX}/usr/share/mathjax" \
		"${D}$(python_get_sitedir)/notebook/static/components/MathJax" || die
}

pkg_preinst() {
	# remove old mathjax folder if present
	rm -rf "${EROOT%/}"/usr/lib*/python*/site-packages/notebook/static/components/MathJax || die
}
