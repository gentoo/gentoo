# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Enthought Tool Suite: collection of core-level utility modules"
HOMEPAGE="https://github.com/enthought/encore"
SRC_URI="http://www.enthought.com/repo/ets/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples test"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		virtual/python-futures[${PYTHON_USEDEP}]
	)"

DOCS=( dataflow.txt )

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	if [[ ${EPYTHON} == python2.6 ]]; then
		ewarn "Tests disabled for ${EPYTHON}"
		return 0
	fi
	nosetests || die
}

python_install_all() {
	distutils-r1_python_install_all

	use doc && dohtml -r docs/build/html/*

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}
