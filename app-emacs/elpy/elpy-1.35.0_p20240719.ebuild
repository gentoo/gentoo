# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

[[ "${PV}" == *p20240719 ]] && COMMIT="c40bab559fe77dcef6b90d5502eba1ecd566e86d"

DISTUTILS_SINGLE_IMPL="ON"
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1 elisp

DESCRIPTION="Emacs Python Development Environment"
HOMEPAGE="https://github.com/jorgenschaefer/elpy/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/jorgenschaefer/${PN}.git"
else
	SRC_URI="https://github.com/jorgenschaefer/${PN}/archive/${COMMIT}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	app-emacs/company-mode
	app-emacs/highlight-indentation
	app-emacs/pyvenv
	app-emacs/s
	app-emacs/yasnippet
	$(python_gen_cond_dep '
		dev-python/flake8[${PYTHON_USEDEP}]
	')
"
BDEPEND="
	${RDEPEND}
	test? (
		$(python_gen_cond_dep '
			dev-python/autopep8[${PYTHON_USEDEP}]
			dev-python/jedi[${PYTHON_USEDEP}]
		')
	)
"

ELISP_REMOVE="
	elpy/tests/test_black.py
	elpy/tests/test_yapf.py
"
PATCHES=(
	"${FILESDIR}/${PN}-elpy.el-yas-snippet-dirs.patch"
	"${FILESDIR}/${PN}-elpy-rpc.el-elpy-rpc-pythonpath.patch"
)

DOCS=( CONTRIBUTING.rst README.rst )
SITEFILE="50${PN}-gentoo.el"

distutils_enable_tests unittest

pkg_setup() {
	elisp_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	rm ${ELISP_REMOVE} || die

	distutils-r1_src_prepare

	sed -i "${PN}.el" \
		-e "s|@SITEETC@|${EPREFIX}${SITEETC}/${PN}|" \
		|| die
	sed -i "${PN}-rpc.el" \
		-e "s|@PYTHONLIB@|${EPREFIX}/usr/lib/${EPYTHON}|" \
		|| die

	sed -i elpy/tests/support.py \
		-e "s|test_should_get_oneline_docstring_for_modules|disabled_&|" \
		|| die
}

src_compile() {
	elisp_src_compile
	distutils-r1_src_compile
}

src_test() {
	distutils-r1_src_test
}

src_install() {
	elisp_src_install
	distutils-r1_src_install

	insinto "${SITEETC}/${PN}"
	doins -r snippets
}
