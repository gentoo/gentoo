# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 versionator

PV_MAJOR_MINOR=$(get_version_component_range 1-2)

DESCRIPTION="CLI Application Framework for Python"
HOMEPAGE="http://builtoncement.com/"
SRC_URI="http://builtoncement.com/${PN}/${PV_MAJOR_MINOR}/source/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test doc"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
	)"

DOCS=( ChangeLog CONTRIBUTORS README.md )
PATCHES=( "${FILESDIR}"/tests-installation.patch )
# https://github.com/cement/cement/issues/185

python_test() {
	nosetests --verbose || die "Tests fail with ${EPYTHON}"
}

python_compile_all() {
	use doc && esetup.py build_sphinx
}

python_install_all() {
	use doc && HTML_DOCS=( doc/build/html/. )

	distutils-r1_python_install_all
}
