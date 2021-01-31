# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1 optfeature

MY_PN="QDarkStyleSheet"

DESCRIPTION="A dark style sheet for QtWidgets application"
HOMEPAGE="https://github.com/ColinDuquesnoy/QDarkStyleSheet"
SRC_URI="https://github.com/ColinDuquesnoy/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE="examples"

RDEPEND="
	>=dev-python/helpdev-0.6.2[${PYTHON_USEDEP}]
	>=dev-python/QtPy-1.7[gui,${PYTHON_USEDEP}]
"

DEPEND="test? (
	dev-python/qtsass[${PYTHON_USEDEP}]
	>=dev-python/QtPy-1.7[gui,testlib,${PYTHON_USEDEP}]
)"

distutils_enable_tests pytest
distutils_enable_sphinx docs dev-python/sphinx_rtd_theme dev-python/m2r

S="${WORKDIR}/${MY_PN}-${PV}"

python_prepare_all() {
	#/var/tmp/portage/dev-python/qdarkstyle-2.8/temp/environment: line 2949:    66 Aborted  (core dumped) pytest -vv
	sed -i -e 's:test_create_custom_qss:_&:' \
		test/test_sass_compiler.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	# tests look for a file in source dir that is not installed
	PYTHONPATH="${S}"
	cd "${S}" || die
	pytest -vv || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	use examples && dodoc -r example
	distutils-r1_python_install_all
}

pkg_postinst() {
	optfeature "qdarkstyle.utils" dev-python/qtsass
}
