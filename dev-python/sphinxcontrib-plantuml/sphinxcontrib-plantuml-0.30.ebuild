# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1

DESCRIPTION="Sphinx extensions for PlantUML"
HOMEPAGE="
	https://github.com/sphinx-contrib/plantuml/
	https://pypi.org/project/sphinxcontrib-plantuml/
"
SRC_URI="
	https://github.com/sphinx-contrib/plantuml/archive/refs/tags/${PV}.tar.gz
		-> ${P}.gh.tar.gz
	https://github.com/sphinx-contrib/plantuml/commit/27ece3637c0ec5fa91cacf511349e290a1440ba9.patch
		-> ${PN}-0.30-fix-tests-python-3.13.patch
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

PATCHES=(
	"${DISTDIR}"/${PN}-0.30-fix-tests-python-3.13.patch
)

distutils_enable_tests pytest

python_test() {
	# Fix for sphinx.errors.ExtensionError: Could not import extension sphinxcontrib.applehelp
	# See https://projects.gentoo.org/python/guide/test.html#importerrors-for-c-extensions, thanks to mgorny.
	rm -rf sphinxcontrib || die

	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
