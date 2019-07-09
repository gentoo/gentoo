# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python{2_7,3_5,3_6} )
PYTHON_MULTIPLE_ABI=1

inherit distutils-r1

DESCRIPTION="Python library for reading and writing COLLADA documents"
HOMEPAGE="https://pycollada.readthedocs.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples test"

RDEPEND="
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.2[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/python-dateutil[${PYTHON_USEDEP}] )
"

REQUIRED_USE="${PYTHON_REQ_USE}"

DOCS=( AUTHORS.md CHANGELOG.rst COPYING README.markdown )

src_compile() {
	distutils-r1_src_compile

	if use doc ; then
		pushd docs > /dev/null || die
		emake html
		popd > /dev/null || die
	fi
}

src_install() {
	distutils-r1_src_install

	use doc && local HTML_DOCS=( docs/_build/html/. )
	einstalldocs

	if use examples ; then
		insinto /usr/share/${P}/
		doins -r examples
	fi

	install_test_data() {
		insinto $(python_get_sitedir)/collada/tests/
		doins -r collada/tests/data
	}
	python_foreach_impl install_test_data
}

src_test() {
	test_collada() {
		for script in "${S}"/collada/tests/*.py ; do
			PYTHONPATH="${S}" $EPYTHON "${script}"
		done
	}
	python_foreach_impl test_collada
}
