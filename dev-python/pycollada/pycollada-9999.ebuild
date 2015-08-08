# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python{2_7,3_3,3_4} )
PYTHON_MULTIPLE_ABI=1

inherit distutils-r1 git-2

DESCRIPTION="python library for reading and writing collada documents"
HOMEPAGE="http://pycollada.github.com/"
EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="doc examples test"

DEPEND="doc? ( dev-python/sphinx )
	test? ( dev-python/python-dateutil )"
RDEPEND="dev-python/numpy
	dev-python/lxml
	>=dev-python/python-dateutil-2.0"

src_compile() {
	distutils-r1_src_compile

	if use doc ; then
		pushd docs
		emake html
		popd
	fi
}

src_install() {
	distutils-r1_src_install

	if use doc ; then
		pushd docs/_build/html
		dohtml -r *
		popd
	fi

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
