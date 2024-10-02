# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_SINGLE_IMPL=true
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 readme.gentoo-r1 virtualx xdg

DESCRIPTION="The highly caffeinated git GUI"
HOMEPAGE="https://git-cola.github.io/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/polib[${PYTHON_USEDEP}]
		dev-python/pygments[${PYTHON_USEDEP}]
		dev-python/QtPy[pyqt6,gui,network,${PYTHON_USEDEP}]
		dev-python/send2trash[${PYTHON_USEDEP}]
	')
	dev-vcs/git
"
BDEPEND="
	sys-devel/gettext
	$(python_gen_cond_dep "
		dev-python/setuptools-scm[\${PYTHON_USEDEP}]
		test? (
			dev-python/pytest[\${PYTHON_USEDEP}]
			dev-python/QtPy[pyqt6,gui,network,\${PYTHON_USEDEP}]
		)
	")
"

distutils_enable_sphinx docs \
	'dev-python/rst-linker'
distutils_enable_tests pytest

src_prepare() {
	sed -i "s|doc/git-cola =|doc/${PF} =|" setup.cfg || die
	# remove bundled qtpy and polib
	rm -Rf qtpy cola/polib.py || die
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
	sed -i "s|import sys|import sys\nimport os\nos.environ['QT_API'] = 'pyqt6'\n|" "${D}"/usr/bin/* || die

	readme.gentoo_create_doc
}
