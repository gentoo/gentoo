# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Python library for reading and writing COLLADA documents"
HOMEPAGE="https://pycollada.readthedocs.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples test"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.2[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( ${RDEPEND} )
"

DOCS=( AUTHORS.md CHANGELOG.rst COPYING README.markdown )

python_compile_all() {
	if use doc ; then
		pushd docs > /dev/null || die
		emake html
		popd > /dev/null || die
	fi
}

python_install_all() {
	if use examples ; then
		insinto /usr/share/${P}/
		doins -r examples
	fi

	use doc && local HTML_DOCS=( docs/_build/html/. )

	distutils-r1_python_install_all
}

python_install() {
	distutils-r1_python_install

	# ensure data files for tests are getting installed too
	python_moduleinto collada/tests/
	python_domodule collada/tests/data
}

python_test() {
	"${EPYTHON}" -m unittest discover -v || die "Tests fail with ${EPYTHON}"
}
