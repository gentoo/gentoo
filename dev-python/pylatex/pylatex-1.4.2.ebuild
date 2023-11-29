# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 optfeature

MY_P="PyLaTeX-${PV}"
DESCRIPTION="A Python library for creating LaTeX files and snippets"
HOMEPAGE="
	https://github.com/JelteF/PyLaTeX/
	https://pypi.org/project/PyLaTeX/
"
SRC_URI="
	https://github.com/JelteF/PyLaTeX/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="examples"

RDEPEND="
	dev-python/ordered-set[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/quantities[${PYTHON_USEDEP}]
		app-text/texlive
		dev-texlive/texlive-latexextra
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	# bug 798381
	sed -i -e 's:description-file:description_file:' setup.cfg || die

	distutils-r1_python_prepare_all
}

python_install_all() {
	if use examples ; then
		dodoc -r examples
		docompress -x /usr/share/doc/"${PF}"/examples
	fi

	distutils-r1_python_install_all
}

pkg_postinst() {
	optfeature "compiling generated files" "
		app-text/texlive
		dev-texlive/texlive-latexextra
		dev-texlive/texlive-mathscience
	"
	optfeature "matplotlib support" dev-python/matplotlib
	optfeature "numpy support" dev-python/numpy
	optfeature "quantities support" dev-python/quantities
}
