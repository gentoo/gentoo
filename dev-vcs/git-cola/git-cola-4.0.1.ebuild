# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_SINGLE_IMPL=true
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 readme.gentoo-r1 virtualx xdg-utils

DESCRIPTION="The highly caffeinated git GUI"
HOMEPAGE="https://git-cola.github.io/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pygments[${PYTHON_USEDEP}]
		dev-python/PyQt5[${PYTHON_USEDEP},gui,widgets]
		dev-python/QtPy[gui,network,${PYTHON_USEDEP}]
		dev-python/send2trash[${PYTHON_USEDEP}]
	')
	dev-vcs/git
"
BDEPEND="sys-devel/gettext
	$(python_gen_cond_dep "
		test? (
			${VIRTUALX_DEPEND}
			dev-python/pytest[\${PYTHON_USEDEP}]
			dev-python/PyQt5[\${PYTHON_USEDEP},gui,widgets]
		)
	")
"

# right now, dev-python/jaraco-packaging is mask, so we cannot generate docs
#distutils_enable_sphinx docs \
#	'>=dev-python/jaraco-packaging-9' \
#	'dev-python/rst-linker'
distutils_enable_tests pytest

src_prepare() {
	sed -i "s|doc/git-cola =|doc/${PF} =|" setup.cfg || die
	sed -i -e 's:--flake8::' pytest.ini || die
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
	readme.gentoo_create_doc
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
