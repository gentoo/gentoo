# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="PyLaTeX"
MY_P="${MY_PN}-${PV}"

PYTHON_COMPAT=( python3_{6,7,8,9} )

inherit distutils-r1 optfeature

DESCRIPTION="A Python library for creating LaTeX files and snippets"
HOMEPAGE="https://github.com/JelteF/PyLaTeX"
SRC_URI="https://github.com/JelteF/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="examples"

RDEPEND="
	dev-python/ordered-set[${PYTHON_USEDEP}]
"

distutils_enable_tests nose

BDEPEND+="
	test? (
		dev-python/quantities[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		app-text/texlive
		dev-texlive/texlive-latexextra
	)"

S="${WORKDIR}/${MY_P}"

python_install_all() {
	if use examples ; then
		dodoc -r examples
		docompress -x /usr/share/doc/"${PF}"/examples
	fi

	distutils-r1_python_install_all
}

pkg_postinst() {
	elog "Optional dependencies:"
	optfeature "compiling generated files" "app-text/texlive dev-texlive/texlive-latexextra dev-texlive/texlive-mathscience"
	optfeature "matplotlib support" dev-python/matplotlib
	optfeature "numpy support" dev-python/numpy
	optfeature "quantities support" dev-python/quantities
}
