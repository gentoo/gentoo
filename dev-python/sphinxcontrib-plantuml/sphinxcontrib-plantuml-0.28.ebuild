# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..12} )

inherit distutils-r1

DESCRIPTION="Sphinx extensions for PlantUML"
HOMEPAGE="
	https://github.com/sphinx-contrib/plantuml/
	https://pypi.org/project/sphinxcontrib-plantuml/
"
SRC_URI="
	https://github.com/sphinx-contrib/plantuml/archive/refs/tags/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"
S="${WORKDIR}/${P#sphinxcontrib-}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 arm64"

BDEPEND="
	test? (
		app-text/texlive
		dev-python/sphinxcontrib-applehelp[${PYTHON_USEDEP}]
		dev-tex/latexmk
		dev-texlive/texlive-fontutils
		dev-texlive/texlive-latexextra
	)
"

distutils_enable_tests pytest

python_test() {
	# Fix for sphinx.errors.ExtensionError: Could not import extension sphinxcontrib.applehelp
	# See https://projects.gentoo.org/python/guide/test.html#importerrors-for-c-extensions, thanks to mgorny.
	rm -rf sphinxcontrib || die

	epytest
}
