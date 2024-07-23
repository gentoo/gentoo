# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_SINGLE_IMPL=true
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 readme.gentoo-r1 virtualx xdg

DESCRIPTION="The highly caffeinated git GUI"
HOMEPAGE="https://git-cola.github.io/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+pyqt5 pyqt6 pyside2 pyside6"

REQUIRED_USE="
	|| ( pyqt5 pyqt6 pyside2 pyside6 )
"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/polib[${PYTHON_USEDEP}]
		dev-python/pygments[${PYTHON_USEDEP}]
		pyqt5? ( dev-python/QtPy[pyqt5,gui,network,${PYTHON_USEDEP}] )
		pyqt6? ( dev-python/QtPy[pyqt6,gui,network,${PYTHON_USEDEP}] )
		pyside2? ( dev-python/QtPy[pyside2,gui,network,${PYTHON_USEDEP}] )
		pyside6? ( dev-python/QtPy[pyside6,gui,network,${PYTHON_USEDEP}] )
		dev-python/send2trash[${PYTHON_USEDEP}]
	')
	dev-vcs/git
"
BDEPEND="
	sys-devel/gettext
	$(python_gen_cond_dep "
		dev-python/setuptools-scm[\${PYTHON_USEDEP}]
		test? (
			${VIRTUALX_DEPEND}
			dev-python/pytest[\${PYTHON_USEDEP}]
			pyqt5? ( dev-python/QtPy[\${PYTHON_USEDEP},pyqt5,gui,network] )
			pyqt6? ( dev-python/QtPy[\${PYTHON_USEDEP},pyqt6,gui,network] )
			pyside2? ( dev-python/QtPy[\${PYTHON_USEDEP},pyside2,gui,network] )
			pyside6? ( dev-python/QtPy[\${PYTHON_USEDEP},pyside6,gui,network] )
		)
	")
"

distutils_enable_sphinx docs \
	'dev-python/rst-linker'
distutils_enable_tests pytest

src_prepare() {
	sed -i "s|doc/git-cola =|doc/${PF} =|" setup.cfg || die
	# remove bundled qtpy and polib
	rm -Rf "${S}"/qtpy "${S}"/cola/polib.py || die
	distutils-r1_src_prepare
}

src_test() {
	virtx distutils-r1_src_test
}

python_test() {
	cd "${T}" || die
	GIT_CONFIG_NOSYSTEM=true LC_ALL="C.utf8" \
	epytest "${S}"/test
}

src_compile() {
	SETUPTOOLS_SCM_PRETEND_VERSION=${PV} distutils-r1_src_compile
}

src_install() {
	distutils-r1_src_install

	# patch the binaries to use desired qtpy backend
	local qt_api=$(use pyqt5 && echo "pyqt5" || (
		use pyqt6 && echo "pyqt6" || (
		use pyside2 && echo "pyside2" || echo "pyside6"
	)))
	sed -i "s|import sys|import sys\nimport os\nos.environ['QT_API'] = '${qt_api}'\n|" "${D}"/usr/bin/* || die

	readme.gentoo_create_doc
}
