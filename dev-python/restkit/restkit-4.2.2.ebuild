# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A HTTP ressource kit for Python"
HOMEPAGE="https://github.com/benoitc/restkit"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ppc64 s390 ~sh x86"
IUSE="+cli doc examples test"
RESTRICT="!test? ( test )"

PY27_USEDEP="$(python_gen_usedep python2_7)"
RDEPEND="cli? ( dev-python/ipython[${PY27_USEDEP}] )
	dev-python/webob[${PYTHON_USEDEP}]
	>=dev-python/socketpool-0.5.3[${PYTHON_USEDEP}]
	>=dev-python/http-parser-0.8.3[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/epydoc[${PY27_USEDEP}] )
	test? ( ${RDEPEND}
		dev-python/nose[${PYTHON_USEDEP}] )"

# prevent duplicate install of data files
PATCHES=( "${FILESDIR}"/setup.patch )

python_compile_all() {
	if use doc ; then
		pushd doc > /dev/null
		emake html
		popd > /dev/null
	fi
}

python_test() {
	nosetests tests || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	use cli || rm "${D}"/usr/bin/restcli* || die
	use doc && local HTML_DOCS=( doc/_build/html/. )
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi

	distutils-r1_python_install_all
}
