# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

H=de31d30003c515c25ff7bfd3a361c70c298f78bb

DISTUTILS_SINGLE_IMPL=ON
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

NEED_EMACS=24.4

inherit distutils-r1 elisp

DESCRIPTION="Emacs Python Development Environment"
HOMEPAGE="https://github.com/jorgenschaefer/elpy/"
SRC_URI="https://github.com/jorgenschaefer/${PN}/archive/${H}.tar.gz
			-> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${H}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-emacs/company-mode
	app-emacs/highlight-indentation
	app-emacs/pyvenv
	app-emacs/s
	app-emacs/yasnippet
	$(python_gen_cond_dep 'dev-python/flake8[${PYTHON_USEDEP}]')
"
BDEPEND="
	${RDEPEND}
	test? (
		$(python_gen_cond_dep '
			dev-python/autopep8[${PYTHON_USEDEP}]
			dev-python/jedi[${PYTHON_USEDEP}]
			dev-python/yapf[${PYTHON_USEDEP}]
		')
	)
"

DOCS=( CONTRIBUTING.rst README.rst )
PATCHES=(
	"${FILESDIR}"/${PN}-elpy.el-yas-snippet-dirs.patch
	"${FILESDIR}"/${PN}-elpy-rpc.el-elpy-rpc-pythonpath.patch
)
SITEFILE="50${PN}-gentoo.el"

distutils_enable_sphinx docs --no-autodoc
distutils_enable_tests unittest

pkg_setup() {
	elisp_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	distutils-r1_src_prepare
	rm elpy/tests/test_black.py || die

	sed -i "s|@SITEETC@|${EPREFIX}${SITEETC}/${PN}|" ${PN}.el || die
	sed -i "s|@PYTHONLIB@|${EPREFIX}/usr/lib/${EPYTHON}|" ${PN}-rpc.el || die
}

src_compile() {
	distutils-r1_src_compile
	elisp_src_compile
}

src_test() {
	distutils-r1_src_test
}

src_install() {
	distutils-r1_src_install

	elisp_src_install
	insinto ${SITEETC}/${PN}
	doins -r snippets
}
