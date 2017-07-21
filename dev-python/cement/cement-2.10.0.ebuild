# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 versionator

PV_MAJOR_MINOR=$(get_version_component_range 1-2)

DESCRIPTION="CLI Application Framework for Python"
HOMEPAGE="http://builtoncement.com/"
SRC_URI="http://builtoncement.com/${PN}/${PV_MAJOR_MINOR}/source/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test doc examples"

RDEPEND="
	dev-python/pystache[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/configobj[${PYTHON_USEDEP}]
	dev-python/pylibmc[${PYTHON_USEDEP}]
	dev-python/genshi[${PYTHON_USEDEP}]
	dev-python/colorlog[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
	)"

DOCS=( ChangeLog CONTRIBUTORS README.md )

PATCHES=( "${FILESDIR}/${PN}"-2.6.2-exmples.patch )

#https://github.com/datafolklabs/cement/issues/331
RESTRICT=test

python_test() {
	nosetests --verbose || die "Tests fail with ${EPYTHON}"
}

python_compile_all() {
	use doc && esetup.py build_sphinx
}

python_install_all() {
	use doc && HTML_DOCS=( doc/build/html/. )
	use examples && EXAMPLES=( examples )

	distutils-r1_python_install_all
}
